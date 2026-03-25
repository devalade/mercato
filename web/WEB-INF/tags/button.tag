<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="href" required="true" type="java.lang.String" %>
<%@ attribute name="variant" required="false" type="java.lang.String" %>
<%@ attribute name="icon" required="false" type="java.lang.String" %>
<%@ attribute name="size" required="false" type="java.lang.String" %>

<c:set var="btnClass" value="btn" />
<c:if test="${not empty size}">
    <c:set var="btnClass" value="${btnClass} btn-${size}" />
</c:if>
<c:choose>
    <c:when test="${variant == 'primary'}"><c:set var="btnClass" value="${btnClass} btn-primary" /></c:when>
    <c:when test="${variant == 'secondary'}"><c:set var="btnClass" value="${btnClass} btn-secondary" /></c:when>
    <c:when test="${variant == 'accent'}"><c:set var="btnClass" value="${btnClass} btn-accent" /></c:when>
    <c:when test="${variant == 'info'}"><c:set var="btnClass" value="${btnClass} btn-info" /></c:when>
    <c:when test="${variant == 'success'}"><c:set var="btnClass" value="${btnClass} btn-success" /></c:when>
    <c:when test="${variant == 'warning'}"><c:set var="btnClass" value="${btnClass} btn-warning" /></c:when>
    <c:when test="${variant == 'error'}"><c:set var="btnClass" value="${btnClass} btn-error" /></c:when>
    <c:when test="${variant == 'ghost'}"><c:set var="btnClass" value="${btnClass} btn-ghost" /></c:when>
    <c:when test="${variant == 'link'}"><c:set var="btnClass" value="${btnClass} btn-link" /></c:when>
    <c:when test="${variant == 'outline'}"><c:set var="btnClass" value="${btnClass} btn-outline" /></c:when>
    <c:otherwise><c:set var="btnClass" value="${btnClass} btn-primary" /></c:otherwise>
</c:choose>

<a href="${href}" class="${btnClass}">
    <c:if test="${not empty icon}">
        <i class="fas ${icon} mr-2"></i>
    </c:if>
    <jsp:doBody />
</a>