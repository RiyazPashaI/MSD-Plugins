<%@include file="/html/common/init.jsp" %>

<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.service.CountryServiceUtil"%>
<%@page import="com.liferay.portal.model.Country"%>
<%@page import="com.liferay.portal.model.ListTypeConstants"%>
<%@page import="com.liferay.portal.model.Contact"%>

<portlet:resourceURL id="getState" var="getState">
	<portlet:param name="<%= Constants.CMD %>" value="getState"/>
</portlet:resourceURL>

<aui:layout>
		<aui:column columnWidth="50" >
			
			<aui:select  label="salutation" listType="<%= ListTypeConstants.CONTACT_PREFIX %>" listTypeFieldName="prefixId" 
				model="<%= Contact.class %>" name="prefixId" showEmptyOption="<%= true %>" />
				
			<aui:input name="firstName" label="First Name"/>
			
			<aui:input name="lastName" label="Last Name"/>
			
			<aui:input name="email" label="Email"/>
			
			<aui:input name="emailStatus" label="Email Status"/>
			
			<aui:input type="checkbox" name="callStatus" label="Do Not Call"></aui:input>
			
			<aui:input name="phone" label="Phone"/>
			
			<aui:input name="mobile" label="Mobile Phone"/>
			
			<aui:input name="otherPhone" label="Other Phone"/>
			
			<aui:input name="homePhone" label="Home Phone"/>
			
			<aui:input name="fax" label="fax"/>
			
			<aui:input type="checkbox" name="isBilling" label="Is Billing Contact"></aui:input>
			
		</aui:column>
		
		<aui:column columnWidth="50" >
		
			<aui:input type="checkbox" name="isAvailable" label="No Longer There"></aui:input>
			
			<aui:input name="department" label="Department"/>
			
			<aui:input name="title" label="Title"/>
			
			<aui:input name="functionalRole" label="Functional Role" />
			
			<aui:input name="secondaryEmail" label="Secondary Email "/>
			
			<aui:input name="emailBounced" label="Reason Email Bounced"/>
			
			<aui:input name="leadSource" label="Lead Source"/>
			
			<aui:input name="assistantName" label="Assistant Name"/>
			
			<aui:input name="assistantPhone" label="Assistant Phone"/>
			
			<aui:input name="assistantEmail" label="Assistant Email"/>
			
		</aui:column>
		<aui:input name="comments" type="textarea"></aui:input>
	</aui:layout>
