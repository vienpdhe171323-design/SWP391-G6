<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.OrderItem" %>
<%@ page import="java.util.List" %>

<%
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    Integer orderId = (Integer) request.getAttribute("orderId");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Order Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>

    <body>

        <div class="container mt-4">

            <h2 class="mb-4 fw-bold">Order #<%= orderId %></h2>

            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Product</th>
                        <th width="100">Qty</th>
                        <th width="150">Unit Price</th>
                        <th width="150">Subtotal</th>
                    </tr>
                </thead>

                <tbody>
                    <% 
                        double total = 0;
                        if (items != null) {
                            for (OrderItem item : items) { 
                                total += item.getSubtotal();
                    %>
                    <tr>
                        <td><%= item.getProductName() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td>$<%= item.getUnitPrice() %></td>
                        <td>$<%= item.getSubtotal() %></td>
                    </tr>
                    <% 
                            }
                        } 
                    %>

                </tbody>

                <tfoot>
                    <tr class="fw-bold table-dark">
                        <td colspan="3">Total</td>
                        <td>$<%= total %></td>
                    </tr>
                </tfoot>
            </table>

            <a href="${pageContext.request.contextPath}/seller/orders22" class="btn btn-secondary mt-3">Back to Orders</a>

        </div>

    </body>
</html>
