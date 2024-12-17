<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/EstudiantesDB";
    String user = "root";
    String password = "Admin$1234";

    Connection conn = null;
    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Actualizar notas y estado si el formulario fue enviado
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id FROM Estudiantes");

            while (rs.next()) {
                int id = rs.getInt("id");
                String notaParam = request.getParameter("nota_" + id);

                if (notaParam != null && !notaParam.isEmpty()) {
                    float nota = Float.parseFloat(notaParam);
                    String estado;

                    // Determinar el estado según la nota
                    if (nota < 65) {
                        estado = "Reprobado";
                    } else if (nota >= 65 && nota < 70) {
                        estado = "Aplazado";
                    } else {
                        estado = "Aprobado";
                    }

                    // Actualizar la base de datos
                    String updateQuery = "UPDATE Estudiantes SET nota = ?, estado = ? WHERE id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                        pstmt.setFloat(1, nota);
                        pstmt.setString(2, estado);
                        pstmt.setInt(3, id);
                        pstmt.executeUpdate();
                    }
                }
            }
        }

        // Consultar los datos de los estudiantes para mostrarlos en el formulario
        String selectQuery = "SELECT id, cedula, nombre, nota, estado FROM Estudiantes";
        Statement selectStmt = conn.createStatement();
        ResultSet rs = selectStmt.executeQuery(selectQuery);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Registro de Notas</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                margin: 20px;
            }
            h1 {
                text-align: center;
                color: #333;
            }
            table {
                margin: 20px auto;
                border-collapse: collapse;
                width: 80%;
                background-color: #fff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            table th, table td {
                padding: 10px;
                text-align: center;
                border: 1px solid #ddd;
            }
            table th {
                background-color: #007bff;
                color: white;
            }
            table tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            table tr:hover {
                background-color: #f1f1f1;
            }
            input[type="text"] {
                width: 80px;
                padding: 5px;
                text-align: center;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            input[type="submit"] {
                display: block;
                margin: 20px auto;
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #0056b3;
            }
  
        </style>
    </head>
    <body>
        <h1>Actualizar Notas de Estudiantes</h1>
        <form method="post" action="notas.jsp">
            <table>
                <tr>
                    <th>Cédula</th>
                    <th>Nombre</th>
                    <th>Nota</th>
                    <th>Estado</th>
                </tr>
                <% while (rs.next()) {%>
                <tr>
                    <td><%= rs.getString("cedula")%></td>
                    <td><%= rs.getString("nombre")%></td>
                    <td>
                        <input type="number" name="nota_<%= rs.getInt("id")%>" 
                               value="<%= rs.getObject("nota") == null ? "" : rs.getFloat("nota")%>"
                               min="0" max="100" step="0.01">
                    </td>

                    <td style="background-color:
                        <%
                            String estado = rs.getString("estado");
                            if ("Reprobado".equals(estado)) { %>
                        red;
                        <% } else if ("Aplazado".equals(estado)) { %>
                        yellow;
                        <% } else if ("Aprobado".equals(estado)) { %>
                        green;
                        <% }%>; color: black;">
                        <%= estado%>
                    </td>

                </tr>
                <% } %>
            </table>
            <input type="submit" value="Guardar">
        </form>
    </body>
</html>

<%
        rs.close();
        selectStmt.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                out.println("<p>Error al cerrar la conexión: " + e.getMessage() + "</p>");
            }
        }
    }
%>
