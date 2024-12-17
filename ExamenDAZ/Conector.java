

package Carpeta; 



import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;



public class Conector {

    private Connection conn;

    public Conector() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservasdatabaseweb", "root", "Admin$1234");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Database driver not found", ex);
        }
    }

    public boolean validateLogin(String txtemail, String txtpassword) throws SQLException {
        if (conn == null || conn.isClosed()) {
            throw new SQLException("Database connection is not available");
        }

        String sql = "SELECT * FROM reservasdatabaseweb.users WHERE email = ? AND pwd = ?";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, txtemail);
            statement.setString(2, txtpassword);
            try (ResultSet resultset = statement.executeQuery()) {
                return resultset.next();
            }
        }
    }

    public void agregarEvento(String nombre, String descripcion, String fecha, String foto, String ubicacion, int entradasDisponibles) throws SQLException {
    String sql = "INSERT INTO Eventos (nombre, descripcion, fecha, foto, ubicacion, entradas_disponibles) VALUES (?, ?, ?, ?, ?, ?)";
    try (PreparedStatement statement = conn.prepareStatement(sql)) {
        statement.setString(1, nombre);
        statement.setString(2, descripcion);
        statement.setString(3, fecha);
        statement.setString(4, foto);
        statement.setString(5, ubicacion);
        
        // Establecer las entradas disponibles
        statement.setInt(6, entradasDisponibles);

        statement.executeUpdate();
    }
}


    public void editarEvento(int id, String nombre, String descripcion, String fecha, String foto, String ubicacion, int entradasDisponibles) throws SQLException {
        String sql = "UPDATE Eventos SET nombre = ?, descripcion = ?, fecha = ?, foto = ?, ubicacion = ?, entradas_disponibles = ? WHERE id = ?";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, nombre);
            statement.setString(2, descripcion);
            statement.setString(3, fecha);
            statement.setString(4, foto);
            statement.setString(5, ubicacion);
            
            statement.setInt(6, entradasDisponibles);
            statement.setInt(7, id);
            statement.executeUpdate();
        }
    } 

    public void eliminarEvento(int id) throws SQLException {
        String sqlReservas = "DELETE FROM Reservas WHERE evento_id = ?";
        try (PreparedStatement statementReservas = conn.prepareStatement(sqlReservas)) {
            statementReservas.setInt(1, id);
            statementReservas.executeUpdate();
        }

        String sql = "DELETE FROM Eventos WHERE id = ?";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        }

    }

    public void Close() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(Conector.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
