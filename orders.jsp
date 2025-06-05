<%@page import="java.text.DecimalFormat"%>
<%@page import="onlinefooddelivery.dao.OrderDao"%>
<%@page import="onlinefooddelivery.connection.DbCon"%>
<%@page import="onlinefooddelivery.dao.RestaurantDao"%>
<%@page import="onlinefooddelivery.model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    DecimalFormat dcf = new DecimalFormat("#.##");
    request.setAttribute("dcf", dcf);
    User loggedInUser = (User) request.getSession().getAttribute("auth");
    List<Order> orders = null;

    if (loggedInUser != null) {
        request.setAttribute("person", loggedInUser);
        OrderDao orderDao = new OrderDao(DbCon.getConnection());
        orders = orderDao.userOrders(loggedInUser.getId());
    } else {
        response.sendRedirect("login.jsp");
        return; // Ensure further code execution is stopped
    }

    ArrayList<Menu> cartList = (ArrayList<Menu>) session.getAttribute("cart-list");
    if (cartList != null) {
        request.setAttribute("cart_list", cartList);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Online Food Delivery</title>
    <%@include file="/includes/head.jsp"%>
</head>
<body>
    <%@include file="/includes/navbar.jsp"%>
    <div class="container">
        <div class="card-header my-3">All Orders</div>
        <table class="table table-light">
            <thead>
                <tr>
                    <th scope="col">Date</th>
                    <th scope="col">Name</th>
                    <th scope="col">Category</th>
                    <th scope="col">Quantity</th>
                    <th scope="col">Price</th>
                    <th scope="col">Cancel</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (orders != null) {
                    for (Order o : orders) {
            %>
                <tr>
                    <td><%= o.getDate() %></td>
                    <td><%= o.getName() %></td>
                    <td><%= o.getCategory() %></td>
                    <td><%= o.getQuantity() %></td>
                    <td><%= dcf.format(o.getPrice()) %></td>
                    <td><a class="btn btn-sm btn-danger" href="cancel-order?id=<%= o.getOrderId() %>">Cancel Order</a></td>
                </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
    <%@include file="/includes/footer.jsp"%>
</body>
</html>
