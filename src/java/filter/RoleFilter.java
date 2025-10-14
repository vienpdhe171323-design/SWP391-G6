package filter;

import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebFilter("/*") // filter tất cả
public class RoleFilter implements Filter {

    // Map đường dẫn → roles được phép (CHỈ bao gồm các trang PRIVATE cần kiểm tra)
    // Đã xóa "/home" khỏi danh sách này để biến nó thành trang PUBLIC
    private static final Map<String, List<String>> roleAccess = new HashMap<>();
    static {
        // Các đường dẫn cần kiểm tra quyền truy cập (Private Pages)
        roleAccess.put("/admin/", Arrays.asList("admin", "3"));
        roleAccess.put("/warehouse/", Arrays.asList("warehouse", "5"));
        roleAccess.put("/seller/", Arrays.asList("seller", "2"));
        roleAccess.put("/manager/", Arrays.asList("manager", "8"));
        roleAccess.put("/finance/", Arrays.asList("finance", "7"));
        roleAccess.put("/cskh/", Arrays.asList("cskh", "6"));
        roleAccess.put("/staff/", Arrays.asList("staff", "4"));
        
        // Ghi chú: `/home` đã bị loại bỏ. Nếu request không khớp với bất kỳ key nào ở trên,
        // nó sẽ được coi là trang công khai và cho phép đi qua.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // --- 1. Xử lý các đường dẫn tĩnh (nên được bỏ qua để đảm bảo hiển thị đúng) ---
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/assets/") || path.startsWith("/images/")) {
             chain.doFilter(request, response);
             return;
        }

        // --- 2. Kiểm tra xem đường dẫn có nằm trong danh sách cần phân quyền không ---
        Optional<String> key = roleAccess.keySet().stream()
                // Thêm điều kiện cho đường dẫn gốc ("/")
                .filter(p -> path.startsWith(p) || path.equals("/")) 
                .findFirst();

        // Nếu request không bắt đầu bằng bất kỳ key nào (bao gồm /home và /)
        if (key.isEmpty() && !path.equals("/")) { // Thêm điều kiện path.equals("/") để loại trừ đường dẫn gốc
            // Nếu không khớp với bất kỳ path nào cần phân quyền -> Coi là trang CÔNG KHAI và cho đi qua
            chain.doFilter(request, response);
            return;
        }

        // --- 3. Kiểm tra ĐĂNG NHẬP nếu đây là trang cần phân quyền (Private Page) ---
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            req.getSession(true).setAttribute("flash_error", "Bạn cần đăng nhập trước để truy cập trang này.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // --- 4. Kiểm tra VAI TRÒ (Role Check) ---
        String role = user.getRole() == null ? "" : user.getRole().toLowerCase();
        
        // Nếu tìm thấy key (trang cần phân quyền)
        if (key.isPresent()) {
            List<String> allowed = roleAccess.get(key.get());

            if (!allowed.contains(role)) {
                // Không có quyền
                session.setAttribute("flash_error", "Bạn không có quyền vào trang này.");
                // Có thể chuyển hướng về trang chủ thay vì login
                resp.sendRedirect(req.getContextPath() + "/home"); 
                return;
            }
        }
        
        // Cho phép đi tiếp
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}