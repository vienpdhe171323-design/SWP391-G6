package controller;

import dao.ShipmentDAO;
import dao.ShipmentEventDAO;
import entity.Shipment;
import entity.ShipmentEvent;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/ajax/track-shipment")
public class ShipmentTrackAjaxServlet extends HttpServlet {

    private final ShipmentDAO shipmentDAO = new ShipmentDAO();
    private final ShipmentEventDAO shipmentEventDAO = new ShipmentEventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        PrintWriter out = resp.getWriter();

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            out.print("{\"error\": \"NOT_LOGIN\"}");
            return;
        }

        // Chỉ Buyer được xem
        if (!("buyer".equalsIgnoreCase(user.getRole()) || "1".equals(user.getRole()))) {
            out.print("{\"error\": \"NO_PERMISSION\"}");
            return;
        }

        // Nhận OrderId
        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            out.print("{\"error\": \"ORDER_ID_REQUIRED\"}");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam);

        // Lấy shipment tương ứng
        Shipment shipment = shipmentDAO.getByOrderId(orderId);
        if (shipment == null) {
            out.print("{\"error\": \"NO_SHIPMENT\"}");
            return;
        }

        // Lấy timeline
        List<ShipmentEvent> events = shipmentEventDAO.getEventsByShipmentId(shipment.getShipmentId());

        // Tạo JSON thủ công
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"shipmentId\":").append(shipment.getShipmentId()).append(",");
        json.append("\"trackingNumber\":\"").append(shipment.getTrackingNumber()).append("\",");
        json.append("\"carrier\":\"").append(shipment.getCarrier()).append("\",");
        json.append("\"status\":\"").append(shipment.getStatus()).append("\",");

        json.append("\"events\":[");
        for (int i = 0; i < events.size(); i++) {
            ShipmentEvent e = events.get(i);
            json.append("{")
                    .append("\"status\":\"").append(e.getStatus()).append("\",")
                    .append("\"time\":\"").append(e.getEventTime()).append("\",")
                    .append("\"location\":\"").append(e.getLocation()).append("\"")
                    .append("}");
            if (i < events.size() - 1) json.append(",");
        }
        json.append("]");

        json.append("}");

        out.print(json.toString());
    }
}
