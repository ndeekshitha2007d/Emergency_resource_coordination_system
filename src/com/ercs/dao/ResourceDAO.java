package com.ercs.dao;

import com.ercs.model.ResourceBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    public boolean updateResourceStatus(int resourceId, String newStatus) {
        String sql = "UPDATE emergency_resources SET status = ? WHERE resource_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // 1. Disable auto-commit to start transaction manually
            conn.setAutoCommit(false);
            
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, resourceId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            // 2. Commit the transaction to write changes permanently to MySQL
            if (rowsUpdated > 0) {
                conn.commit();
                System.out.println("DEBUG: Successfully updated and committed resource ID: " + resourceId);
                return true;
            } else {
                conn.rollback();
                System.out.println("DEBUG: No matching row found for resource ID: " + resourceId);
                return false;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ResourceBean> getAllResourcesWithMetadata() {
        List<ResourceBean> list = new ArrayList<>();
        String sql = "SELECT * FROM emergency_resources";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            ResultSetMetaData rsmd = rs.getMetaData();
            System.out.println("Executing Query against Table: " + rsmd.getTableName(1));

            while (rs.next()) {
                ResourceBean res = new ResourceBean();
                res.setResourceId(rs.getInt("resource_id"));
                res.setResourceName(rs.getString("resource_name"));
                res.setCategory(rs.getString("category"));
                res.setStatus(rs.getString("status"));
                list.add(res);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean logDispatchEvent(int resourceId, String incidentType, String severity) {
        String sql = "INSERT INTO dispatch_logs (resource_id, incident_type, severity) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resourceId);
            pstmt.setString(2, incidentType);
            pstmt.setString(3, severity);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}