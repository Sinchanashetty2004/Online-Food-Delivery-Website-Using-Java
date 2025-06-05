
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="onlinefooddelivery.dao.RestaurantDao" %>
<%@ page import="onlinefooddelivery.connection.DbCon" %>
<%@ page import="onlinefooddelivery.model.User" %>
<%@ page import="onlinefooddelivery.model.Restaurant" %>
<%@ page import="onlinefooddelivery.model.Menu" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">ṇ
    <title>Home Page</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">Online Food Delivery</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="cart.jsp">Cart <span class="badge badge-danger"><%= (session.getAttribute("cart-list") != null) ? ((ArrayList<Menu>)session.getAttribute("cart-list")).size() : 0 %></span></a></li>
                    <%
                    User auth = (User) request.getSession().getAttribute("auth");
                    if (auth != null) {
                    %>
                    <li class="nav-item"><a class="nav-link" href="orders.jsp">Orders</a></li>
                    <li class="nav-item"><a class="nav-link" href="log-out">Logout</a></li>
                    <%
                    } else {
                    %>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                    <%
                    }
                    %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <%
        if (auth != null) {
            request.setAttribute("auth", auth);
        }

        RestaurantDao pd = new RestaurantDao(DbCon.getConnection());
        List<Restaurant> products = pd.getAllRestaurants();

        ArrayList<Menu> cart_list = (ArrayList<Menu>) session.getAttribute("cart-list");
        if (cart_list != null) {
            request.setAttribute("cart_list", cart_list);
        }
        %>

        <div class="cart-header my-3">All Products</div>
        <div class="row">
            <%
            if (products != null && !products.isEmpty()) {
                for (Restaurant p : products) {
            %>
            <div class="col-md-3 my-3">
                <div class="card w-100" style="width: 18rem;">
                    <img class="card-img-top" src="<%= p.getImage() %>" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title"><%= p.getName() %></h5>
                        <h6 class="price">Price: ₹<%= p.getPrice() %></h6>
                        <h6 class="category">Category: <%= p.getCategory() %></h6>
                        <div class="mt-3 d-flex justify-content-between">
                            <a href="add-to-cart?id=<%= p.getId() %>" class="btn btn-primary">Add To Cart</a>
                            <a class="btn btn-primary" href="order-now?quantity=1&id=<%= p.getId() %>">Buy Now</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            }
            %>
        </div>
    </div>

    <!-- Include Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
