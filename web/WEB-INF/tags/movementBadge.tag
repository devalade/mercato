<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="type" required="true" type="java.lang.String" %>

<c:set var="badgeClass" value="badge" />
<c:set var="typeLabel" value="${type}" />
<c:set var="iconClass" value="" />

<c:choose>
    <c:when test="${type == 'ENTREE'}">
        <c:set var="badgeClass" value="badge badge-success gap-2" />
        <c:set var="typeLabel" value="Entrée" />
        <c:set var="iconClass" value="fas fa-arrow-down" />
    </c:when>
    <c:when test="${type == 'SORTIE'}">
        <c:set var="badgeClass" value="badge badge-error gap-2" />
        <c:set var="typeLabel" value="Sortie" />
        <c:set var="iconClass" value="fas fa-arrow-up" />
    </c:when>
    <c:when test="${type == 'AFFECTATION'}">
        <c:set var="badgeClass" value="badge badge-info gap-2" />
        <c:set var="typeLabel" value="Affectation" />
        <c:set var="iconClass" value="fas fa-user-plus" />
    </c:when>
    <c:when test="${type == 'RETOUR'}">
        <c:set var="badgeClass" value="badge badge-warning gap-2" />
        <c:set var="typeLabel" value="Retour" />
        <c:set var="iconClass" value="fas fa-undo" />
    </c:when>
</c:choose>

<span class="${badgeClass}">
    <c:if test="${not empty iconClass}">
        <i class="${iconClass}"></i>
    </c:if>
    ${typeLabel}
</span>