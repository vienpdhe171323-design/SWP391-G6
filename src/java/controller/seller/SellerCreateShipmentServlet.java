package controller.seller;

import dao.OrderDAO;
import dao.ShipmentDAO;
import dao.ShipmentEventDAO;
import entity.Shipment;
import entity.ShipmentEvent;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
@WebServlet("/seller/create-shipment")
public class SellerCreateShipmentServlet extends HttpServlet {
    private final ShipmentDAO shipmentDAO = new ShipmentDAO();
    private final ShipmentEventDAO eventDAO = new ShipmentEventDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String carrier = req.getParameter("carrier");
        String tracking = req.getParameter("trackingNumber");

        // 1️⃣ Tạo shipment mới
        Shipment s = new Shipment();
        s.setOrderId(orderId);
        s.setCarrier(carrier);
        s.setTrackingNumber(tracking);
        s.setStatus("CREATED");

        boolean ok = shipmentDAO.createShipment(s);

        if (ok) {
            // 2️⃣ Lấy ShipmentId vừa tạo
            Shipment created = shipmentDAO.getByOrderId(orderId);
            if (created != null) {
                // 3️⃣ Tạo ShipmentEvent đầu tiên
                ShipmentEvent e = new ShipmentEvent();
                e.setShipmentId(created.getShipmentId());
                e.setStatus("CREATED");
                e.setLocation("Kho Người Bán");
                eventDAO.addEvent(e);
            }

            orderDAO.updateStatus(orderId, "Confirmed");

            session.setAttribute("msg", "Tạo Shipment thành công! Đơn đã chuyển sang trạng thái Confirmed.");
            session.setAttribute("msgType", "success");
        } else {
            session.setAttribute("msg", "Tạo Shipment thất bại!");
            session.setAttribute("msgType", "danger");
        }

        // 5️⃣ Redirect trở lại danh sách chờ Shipment
        resp.sendRedirect(req.getContextPath() + "/seller/orders");
    }
}
