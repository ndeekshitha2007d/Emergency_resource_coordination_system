<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.ercs.model.ResourceBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERCS - Operator Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #dc2626;
            --primary-hover: #b91c1c;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success-bg: #dcfce7;
            --success-text: #15803d;
            --failed-bg: #fee2e2;
            --failed-text: #b91c1c;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .dashboard-container {
            max-width: 1000px;
            width: 100%;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--border);
        }

        .header h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-badge {
            background-color: #fef2f2;
            color: var(--primary);
            font-size: 12px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid #fecaca;
        }

        /* Status Banner / Cards */
        .status-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .status-info {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .status-label {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pill {
            display: inline-block;
            font-size: 13px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 6px;
            width: fit-content;
        }

        .status-pill.success {
            background-color: var(--success-bg);
            color: var(--success-text);
        }

        .status-pill.failed {
            background-color: var(--failed-bg);
            color: var(--failed-text);
        }

        .incident-detail {
            font-size: 15px;
            color: var(--text-main);
            font-weight: 500;
        }

        /* Inventory Table Section */
        .table-section {
            background: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .table-header {
            padding: 20px;
            border-bottom: 1px solid var(--border);
            background-color: #ffffff;
        }

        .table-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-main);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 14px 20px;
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: #f8fafc;
        }

        .resource-id {
            font-family: monospace;
            font-weight: 600;
            color: #3b82f6;
            background-color: #eff6ff;
            padding: 3px 8px;
            border-radius: 4px;
        }

        .badge-status {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 8px;
            border-radius: 4px;
            text-transform: uppercase;
        }

        .badge-dispatched {
            background-color: #fef3c7;
            color: #d97706;
        }

        .badge-available {
            background-color: var(--success-bg);
            color: var(--success-text);
        }

        /* Action Link Button */
        .footer-action {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: var(--primary);
            color: #ffffff;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            padding: 10px 18px;
            border-radius: 8px;
            transition: background-color 0.2s ease, transform 0.1s ease;
            box-shadow: 0 2px 4px rgba(220, 38, 38, 0.2);
        }

        .btn-back:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .empty-row {
            text-align: center;
            color: var(--text-muted);
            padding: 30px;
        }
    </style>
</head>
<body>

<div class="dashboard-container">

    <!-- Dashboard Header -->
    <div class="header">
        <h2>
            🚨 Emergency Resource Coordination
        </h2>
        <span class="header-badge">Live System</span>
    </div>

    <!-- Session Status Card -->
    <%
        String dispatchStatus = (String) session.getAttribute("lastDispatchStatus");
        String recentIncident = (String) session.getAttribute("recentIncident");
        if (dispatchStatus != null) {
    %>
        <div class="status-card">
            <div class="status-info">
                <span class="status-label">Last Operation Status</span>
                <span class="status-pill <%= "SUCCESS".equals(dispatchStatus) ? "success" : "failed" %>">
                    ● <%= dispatchStatus %>
                </span>
            </div>
            <% if (recentIncident != null) { %>
                <div class="status-info" style="text-align: right;">
                    <span class="status-label">Active Incident</span>
                    <span class="incident-detail"><%= recentIncident %></span>
                </div>
            <% } %>
        </div>
    <% 
        } 
    %>

    <!-- Resource Inventory Table -->
    <div class="table-section">
        <div class="table-header">
            <h3>Resource Inventory</h3>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Resource ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<ResourceBean> resources = (List<ResourceBean>) request.getAttribute("resources");
                    if (resources != null && !resources.isEmpty()) {
                        for (ResourceBean res : resources) {
                            String statusClass = "DISPATCHED".equalsIgnoreCase(res.getStatus()) ? "badge-dispatched" : "badge-available";
                %>
                    <tr>
                        <td><span class="resource-id">RES-<%= res.getResourceId() %></span></td>
                        <td><strong><%= res.getResourceName() %></strong></td>
                        <td><%= res.getCategory() %></td>
                        <td><span class="badge-status <%= statusClass %>"><%= res.getStatus() %></span></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="4" class="empty-row">No resources found or table not loaded.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Back Action Button -->
    <div class="footer-action">
        <a href="dispatch_request.html" class="btn-back">
            ← Back to Dispatch Form
        </a>
    </div>

</div>

</body>
</html>