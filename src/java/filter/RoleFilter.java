package filter;

import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebFilter("/*") // filter tất cả
public class RoleFilter implements Filter {

    // Map đường dẫn → roles được phép
    private static final Map<String, List<String>> roleAccess = new HashMap<>();
    static {
        roleAccess.put("/admin/", Arrays.asList("admin","3"));
        roleAccess.put("/warehouse/", Arrays.asList("warehouse","5"));
        roleAccess.put("/seller/", Arrays.asList("seller","2"));
        roleAccess.put("/manager/", Arrays.asList("manager","8"));
        roleAccess.put("/finance/", Arrays.asList("finance","7"));
        roleAccess.put("/cskh/", Arrays.asList("cskh","6"));
        roleAccess.put("/staff/", Arrays.asList("staff","4"));
        roleAccess.put("/home", Arrays.asList("buyer","1","admin","3","seller","2")); 
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Nếu request không nằm trong các key roleAccess thì cho qua (public page)
        Optional<String> key = roleAccess.keySet().stream()
                .filter(path::startsWith)
                .findFirst();

        if (key.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }

        // Check user login
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            req.getSession(true).setAttribute("flash_error", "Bạn cần đăng nhập trước");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // role check
        String role = user.getRole() == null ? "" : user.getRole().toLowerCase();
        List<String> allowed = roleAccess.get(key.get());

        if (!allowed.contains(role)) {
            session.setAttribute("flash_error", "Bạn không có quyền vào trang này.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Cho phép đi tiếp
        chain.doFilter(request, response);
    }
}
