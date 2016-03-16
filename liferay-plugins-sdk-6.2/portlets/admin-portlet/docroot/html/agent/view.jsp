<%@ include file="/html/common/init.jsp"%>

<portlet:renderURL var="tabsURL"/>
<%
	String currentTab = ParamUtil.getString(renderRequest, "agent-tabs", "agent-list");
%>
<liferay-ui:tabs names="agent-list,create-new,manage-agent-preferences" param="agent-tabs" value="<%= currentTab %>" url="${tabsURL}">
	<liferay-ui:section>
		<%@include file="/html/agent/agent-list.jsp" %>
	</liferay-ui:section>
	<liferay-ui:section>
		<%@include file="/html/agent/create-new.jsp" %>
	</liferay-ui:section>
	<liferay-ui:section>
		<%@include file="/html/agent/manage-preferences.jsp" %>
	</liferay-ui:section>
</liferay-ui:tabs>