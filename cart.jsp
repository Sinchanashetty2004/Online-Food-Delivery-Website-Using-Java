<%@ page import="onlinefooddelivery.dao.RestaurantDao" %>
<%@ page import="onlinefooddelivery.connection.DbCon" %>
<%@ page import="onlinefooddelivery.model.User" %>
<%@ page import="onlinefooddelivery.model.Menu" %>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
DecimalFormat dcf = new DecimalFormat("#.##");
request.setAttribute("dcf", dcf);
User loggedInUser = (User) request.getSession().getAttribute("auth");
if (loggedInUser != null) {
    request.setAttribute("person", loggedInUser);
}

ArrayList<Menu> cartList = (ArrayList<Menu>) session.getAttribute("cart-list");
List<Menu> cartProduct = null;
double total = 0.0;

if (cartList != null) {
    RestaurantDao pDao = new RestaurantDao(DbCon.getConnection());
    cartProduct = pDao.getCartProducts(cartList);
    total = pDao.getTotalMenuPrice(cartList);
    request.setAttribute("total", total);
    request.setAttribute("cart_list", cartList);
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Online Food Delivery</title>
    <%@include file="/includes/head.jsp"%>
    <style type="text/css">
        .table tbody td {
            vertical-align: middle;
        }
        .btn-incre, .btn-decre {
            box-shadow: none;
            font-size: 25px;
        }
    </style>
</head>
<body>
    <%@include file="/includes/navbar.jsp"%>
    <div class="container my-3">
        <div class="d-flex py-3">
            <h3>Total Price: $ <%= (total > 0) ? dcf.format(total) : 0 %> </h3> 
            <a class="mx-3 btn btn-primary" href="cart-check-out">Check Out</a>
        </div>
        <table class="table table-light">
            <thead>
                <tr>
                    <th scope="col">Name</th>
                    <th scope="col">Category</th>
                    <th scope="col">Price</th>
                    <th scope="col">Buy Now</th>
                    <th scope="col">Cancel</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (cartList != null && cartProduct != null) {
                    for (Menu c : cartProduct) {
                %>
                <tr>
                    <td><%= c.getName() %></td>
                    <td><%= c.getCategory() %></td>
                    <td><%= dcf.format(c.getPrice()) %></td>
                    <td>
                        <form action="order-now" method="post" class="form-inline">
                            <input type="hidden" name="id" value="<%= c.getId() %>" class="form-input">
                            <div class="form-group d-flex justify-content-between">
                                <a class="btn btn-sm btn-incre" href="quantity-inc-dec?action=inc&id=<%= c.getId() %>">
                                    <i class="fas fa-plus-square"></i>
                                </a> 
                                <input type="text" name="quantity" class="form-control" value="<%= c.getQuantity() %>" readonly> 
                                <a class="btn btn-sm btn-decre" href="quantity-inc-dec?action=dec&id=<%= c.getId() %>">
                                    <i class="fas fa-minus-square"></i>
                                </a>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">Buy</button>
                        </form>
                    </td>
                    <td>
                        <a href="remove-from-cart?id=<%= c.getId() %>" class="btn btn-sm btn-danger">Remove</a>
                    </td>
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
