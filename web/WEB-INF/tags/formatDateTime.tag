<%@ tag import="java.time.format.DateTimeFormatter" %>
<%@ tag import="java.time.LocalDateTime" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="date" required="true" type="java.time.LocalDateTime" %>
<%@ attribute name="pattern" required="false" type="java.lang.String" %>
<c:choose>
    <c:when test="${date != null}">
        <%
            LocalDateTime date = (LocalDateTime) jspContext.getAttribute("date");
            String pattern = (String) jspContext.getAttribute("pattern");
            if (pattern == null || pattern.trim().isEmpty()) {
                pattern = "dd/MM/yyyy HH:mm";
            }
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
                out.print(date.format(formatter));
            } catch (Exception e) {
                out.print("Invalid date format");
            }
        %>
    </c:when>
    <c:otherwise>
        <span class="text-base-content/40">-</span>
    </c:otherwise>
</c:choose>
