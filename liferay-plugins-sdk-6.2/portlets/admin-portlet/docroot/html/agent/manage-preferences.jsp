<%@page import="com.liferay.portal.service.CompanyLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Company"%>
<%@ include file="/html/common/init.jsp"%>

<%
	List<Company> companyList = CompanyLocalServiceUtil.getCompanies();
%>
<aui:form>
	
	<aui:select name="agent" showEmptyOption="true">
		<%
			for(Company comp : companyList) {
				%>
					<aui:option label="<%=comp.getName()%>" value="<%=comp.getCompanyId()%>"/>
				<%
			}
		%>
	</aui:select>
	<aui:input name="default-display-mode" />
	<aui:input name="download-fee-percent" />
	<aui:select name="sort-by-customer-id" showEmptyOption="true">
		<aui:option label="Yes" value="Yes"/>
		<aui:option label="No" value="No"/>
	</aui:select>
	<aui:select name="date-format" showEmptyOption="true">
		<aui:option label="mm/dd/yyyy" value="mm/dd/yyyy"/>
		<aui:option label="dd/mm/yyyy" value="dd/mm/yyyy"/>
		<aui:option label="yyyy/mm/dd" value="yyyy/mm/dd"/>
	</aui:select>
	<aui:select name="payment-provider" showEmptyOption="true">
		<aui:option label="Paypal" value="Paypal"/>
		<aui:option label="Cybersource" value="Cybersource"/>
	</aui:select>
	<aui:input name="disable-average-download-emails" type="checkbox"/>
	<aui:button type="submit" value='<%=LanguageUtil.get(pageContext, "save") %>' />
</aui:form>