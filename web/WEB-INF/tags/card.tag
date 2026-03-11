<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="icon" required="false" %>
<%@ attribute name="variant" required="false" type="java.lang.String" %>

<c:set var="bgClass" value="bg-base-100" />
<c:choose>
    <c:when test="${variant == 'primary'}"><c:set var="bgClass" value="bg-primary text-primary-content" /></c:when>
    <c:when test="${variant == 'secondary'}"><c:set var="bgClass" value="bg-secondary text-secondary-content" /></c:when>
    <c:when test="${variant == 'accent'}"><c:set var="bgClass" value="bg-accent text-accent-content" /></c:when>
</c:choose>

<div class="card ${bgClass} shadow-xl mb-6">
    <div class="card-body">
        <h2 class="card-title text-2xl">
            <c:if test="${not empty icon}">
                <i class="fas ${icon}"></i>
            </c:if>
            ${title}
        </h2>
        <jsp:doBody />
    </div>
</div>