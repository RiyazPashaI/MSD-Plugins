<%@include file="/html/common/init.jsp" %>

<%
	String tabs1 = ParamUtil.getString(request, "tabs1", "Search");
	String tabNames = "Search,Create New" ;

%>
<portlet:renderURL var="tabsURL">
	<portlet:param name="tabs1" value="<%= tabs1 %>" />
</portlet:renderURL>

 <portlet:renderURL var="searchURL">
	<portlet:param name="jspPage" value="/html/customer/view.jsp" />
	<portlet:param name="tabs1" value="Search" />
</portlet:renderURL>
<portlet:renderURL var="createURL">
	<portlet:param name="jspPage" value="/html/customer/view.jsp" />
	<portlet:param name="tabs1" value="Create New" />
</portlet:renderURL>

<liferay-ui:tabs names="Search,Create New" param="tabs1" url="<%=tabsURL %>" url0="<%=searchURL %>" url1="<%=createURL %>" value="<%=tabs1 %>"/>
	<c:if test='<%= tabs1.equals("Search") %>'>
  		<%@include file="/html/customer/search.jsp"%>	
	</c:if>
	<c:if test='<%= tabs1.equals("Create New") %>'>
  		<%@include file="/html/customer/createcustomer.jsp"%>	
	</c:if>	



