<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="status" required="true" type="java.lang.String" %>

<c:set var="badgeClass" value="badge" />
<c:set var="statusLabel" value="${status}" />

<c:choose>
    <c:when test="${status == 'EN_STOCK'}">
        <c:set var="badgeClass" value="badge badge-success" />
        <c:set var="statusLabel" value="En stock" />
    </c:when>
    <c:when test="${status == 'AFFECTE'}">
        <c:set var="badgeClass" value="badge badge-info" />
        <c:set var="statusLabel" value="Affecté" />
    </c:when>
    <c:when test="${status == 'HORS_SERVICE'}">
        <c:set var="badgeClass" value="badge badge-error" />
        <c:set var="statusLabel" value="Hors service" />
    </c:when>
    <c:when test="${status == 'EXPIRE'}">
        <c:set var="badgeClass" value="badge badge-warning" />
        <c:set var="statusLabel" value="Expiré" />
    </c:when>
</c:choose>

<span class="${badgeClass}">${statusLabel}</span>