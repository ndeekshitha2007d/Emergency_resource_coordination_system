package com.ercs.controller;

import com.ercs.dao.ResourceDAO;
import com.ercs.model.ResourceBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dispatch")
public class DispatchServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String incidentType = request.getParameter("incidentType");
        String severity = request.getParameter("severity");
        String rawResourceId = request.getParameter("resourceId");

        System.out.println("\n--- [DEBUG DispatchServlet] NEW DISPATCH REQUEST RECEIVED ---");
        System.out.println("[DEBUG] Raw Input - Incident: " + incidentType + " | Severity: " + severity + " | ResourceID: " + rawResourceId);

        // 1. Validate raw input prefix
        if (rawResourceId == null || !rawResourceId.startsWith("RES-")) {
            System.out.println("[DEBUG ERROR] Invalid ID format (Missing 'RES-' prefix): " + rawResourceId);
            response.sendRedirect(request.getContextPath() + "/dispatch_request.html");
            return;
        }

        // 2. Safely parse numeric portion of Resource ID
        int parsedResourceId;
        try {
            parsedResourceId = Integer.parseInt(rawResourceId.replace("RES-", "").trim());
            System.out.println("[DEBUG] Parsed Integer ID for SQL query: " + parsedResourceId);
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG ERROR] NumberFormatException while parsing ID: " + rawResourceId);
            HttpSession session = request.getSession(true);
            session.setAttribute("lastDispatchStatus", "INVALID_ID_FORMAT");
            response.sendRedirect(request.getContextPath() + "/dispatch_request.html");
            return;
        }

        // 3. Update status in database
        ResourceDAO dao = new ResourceDAO();
        boolean isUpdated = dao.updateResourceStatus(parsedResourceId, "DISPATCHED");
        System.out.println("[DEBUG] Update Status Result from DAO: " + isUpdated);

        HttpSession session = request.getSession(true);
        if (isUpdated) {
            // 4. Record historical entry in dispatch_logs table
            boolean isLogged = dao.logDispatchEvent(parsedResourceId, incidentType, severity);
            System.out.println("[DEBUG] Log Inserted into dispatch_logs: " + isLogged);

            session.setAttribute("lastDispatchStatus", "SUCCESS");
            session.setAttribute("recentIncident", incidentType);

            Cookie operatorCookie = new Cookie("lastActiveOperator", "Dispatcher_Unit_1");
            operatorCookie.setMaxAge(60 * 60 * 24);
            response.addCookie(operatorCookie);
        } else {
            session.setAttribute("lastDispatchStatus", "FAILED");
        }

        // 5. Fetch fresh inventory data and forward to dashboard
        List<ResourceBean> resourceList = dao.getAllResourcesWithMetadata();
        System.out.println("[DEBUG] Total resources fetched for dashboard: " + (resourceList != null ? resourceList.size() : 0));
        
        request.setAttribute("resources", resourceList);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dispatch_request.html");
    }
}