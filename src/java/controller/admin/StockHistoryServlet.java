package controller.admin;

import dao.StockMovementDAO;
import entity.StockMovement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.PagedResult;

import java.io.IOException;

@WebServlet("/admin/stock-history")
public class StockHistoryServlet extends HttpServlet {
    private final StockMovementDAO dao = new StockMovementDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        String type = req.getParameter("type"); // IN / OUT
        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int size = parseIntOrDefault(req.getParameter("size"), 10);

        PagedResult<StockMovement> result = dao.getHistory(search, type, page, size);

        req.setAttribute("result", result);
        req.setAttribute("search", search == null ? "" : search);
        req.setAttribute("type", type == null ? "" : type);
        req.setAttribute("size", size);
        req.getRequestDispatcher("stock-history.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String s, int d) {
        try { return Integer.parseInt(s); } catch (Exception e) { return d; }
    }
}
