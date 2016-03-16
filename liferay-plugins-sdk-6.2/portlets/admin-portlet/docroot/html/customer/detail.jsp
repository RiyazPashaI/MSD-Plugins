<%@include file="/html/common/init.jsp" %>

<portlet:resourceURL id="getState" var="getState">
	<portlet:param name="<%= Constants.CMD %>" value="getState"/>
</portlet:resourceURL>

<%
	User customerInfo = CommonUtil.getOrgAdmin(customerId);

	long customerUserId = (Validator.isNotNull(customerInfo)) ? customerInfo.getUserId() : 0;
	
	String firstName = (Validator.isNotNull(customerInfo)) ? customerInfo.getFirstName() : StringPool.BLANK;
	String lastName = (Validator.isNotNull(customerInfo)) ? customerInfo.getLastName() : StringPool.BLANK;
	String jobTitle = (Validator.isNotNull(customerInfo)) ? customerInfo.getJobTitle() : StringPool.BLANK;
	String emailAddress = (Validator.isNotNull(customerInfo)) ? customerInfo.getEmailAddress() : StringPool.BLANK;
	
	Phone phoneNum = null;
	Phone fax = null;
	Phone tollfree = null;
	Address address = null;
	
	long countryId = 0;
	long regionId = 0;
	long organizationId = (Validator.isNotNull(organization) ? organization.getOrganizationId() : 0);
	try {
		phoneNum = CommonUtil.getPhoneByTypeId(customerUserId, companyId, "phone");
		fax = CommonUtil.getPhoneByTypeId(customerUserId, companyId, "fax");
		tollfree = CommonUtil.getPhoneByTypeId(organization.getOrganizationId(), companyId, "toll-free");
		address = CommonUtil.getAddress(customerInfo.getUserId(), User.class.getName());
		countryId = Validator.isNotNull(address) ? address.getCountryId() : 0;
		regionId = Validator.isNotNull(address) ? address.getRegionId() : 0;
	} catch (NullPointerException e) {
		System.out.println(e);
	}
%>

<aui:layout>
		<aui:column columnWidth="50" >
			<aui:input name="websiteId" type="hidden" value='<%= CommonUtil.getWebsiteId(company.getCompanyId(), organizationId, Organization.class.getName()) %>'/>
			<aui:input name="userId" type="hidden" value='<%= (Validator.isNotNull(customerInfo) ? customerInfo.getUserId() : 0) %>'/> 
			<aui:input name="organizationId" type="hidden" value='<%= organizationId  %>'/> 
			<aui:input name="addressId" type="hidden" value='<%= (Validator.isNotNull(address) ? address.getAddressId() : 0)  %>'/> 
			<aui:input name="phoneNumId" type="hidden" value='<%= (Validator.isNotNull(phoneNum) ? phoneNum.getPhoneId() : 0) %>'/>
			<aui:input name="phonefaxId" type="hidden" value='<%= (Validator.isNotNull(fax) ? fax.getPhoneId() : 0) %>'/>
			<aui:input name="phonetollfreeId" type="hidden" value='<%= (Validator.isNotNull(tollfree) ? tollfree.getPhoneId() : 0) %>'/>
			<aui:input name="parentCompany" label="Parent Company" value="<%= parentCompany %>"/>
			
			<aui:select name="salesPerson">
				<aui:option value="-1">Unassigned</aui:option>
			</aui:select>
			
			<aui:select  label="salutation" listType="<%= ListTypeConstants.CONTACT_PREFIX %>" listTypeFieldName="prefixId" 
				model="<%= Contact.class %>" name="prefixId" showEmptyOption="<%= true %>" 
				bean="<%= (Validator.isNotNull(customerInfo)) ? customerInfo.getContact() : null %>" 
			/>
				
			<aui:input name="firstName" label="First Name" value="<%= firstName %>"/>
			
			<aui:input name="lastName" label="Last Name" value="<%= lastName %>"/>
			
			<aui:input name="phone" label="Phone" value='<%= (Validator.isNotNull(phoneNum)) ? phoneNum.getNumber() : StringPool.BLANK %>'/>
			
			<aui:input name="title" label="Title" value="<%= jobTitle %>"/> 
			
			<aui:input name="email" label="Email" value="<%= emailAddress %>"/> 
			
			<aui:input name="fax" label="Fax" value='<%= (Validator.isNotNull(fax)) ? fax.getNumber() : StringPool.BLANK %>'/>
		</aui:column>
		<aui:column columnWidth="50" >
			<aui:input name="companyNumber" label="Toll Free Phone"  value='<%= (Validator.isNotNull(tollfree)) ? tollfree.getNumber() : StringPool.BLANK  %>'/>
			<aui:input name="companyWebsite" label="Company Website" value='<%= CommonUtil.getCompanyWebsite(company.getCompanyId(), organizationId, Organization.class.getName()) %>'/>
			<aui:input name="address" label="Address" value='<%= (Validator.isNotNull(address) ? address.getStreet1() : StringPool.BLANK) %>'/>
			<aui:input name="address2" label="address2 " value='<%= (Validator.isNotNull(address) ? address.getStreet2() : StringPool.BLANK) %>'/>
			<aui:input name="city" label="City" value='<%= (Validator.isNotNull(address) ? address.getCity() : StringPool.BLANK) %>'/>
			<aui:input name="postcode" label="Postal Code" value='<%= (Validator.isNotNull(address) ? address.getZip() : StringPool.BLANK) %>'/>
			<aui:select name="countryId" id="countryId" label="country" onChange="javascript:changeState(this.value);" >
				<aui:option value="-1" label="--Please Select--"></aui:option>
				<%
				for (Country country:CountryServiceUtil.getCountries()) { 
					%><aui:option value="<%= country.getCountryId() %>" label="<%= TextFormatter.format(country.getName(), TextFormatter.J) %>"  selected="<%= country.getCountryId() == countryId %>"/><%  
				}
				%>
			</aui:select>
			
			<aui:select name="regionId" id="regionId" label="Region"> 
				<aui:option value="" label="--Please Select--"></aui:option>
			</aui:select>
		</aui:column>
	<aui:input name="comments" type="textarea" value='<%= comment %>'></aui:input>
</aui:layout>

<script type="text/javascript">
	$(document).ready(function(){
		<c:if test='<%= Validator.isNotNull(customer) %>'>
			makeAjaxCall('<%= getState.toString() %>', '<%= countryId %>');
		</c:if>
	});

	function changeState(val) {
		makeAjaxCall('<%= getState.toString() %>',val);
	}
	
	function makeAjaxCall(url,val) {
		$.ajax({
			url : url,
			data: { 
				countryId:val
			},
			type: 'POST',
		  	dataType : "json",
		  	success : function(data) {
				$('#<portlet:namespace/>regionId').html('');
				var regionDefaultlabel = (data.length == 0) ? "No States" : "----Please select----";
				$('#<portlet:namespace/>regionId').append('<option value="" >'+regionDefaultlabel+'</option>'); 
				populateDropDowns(data,'regionId');	
		  	}	
		});
	}
	
	function populateDropDowns(data,id) {
		var state = document.getElementById('<portlet:namespace/>regionId');
		if (data.length > 0) {
			state.options.length = data.length;
			for (var i=0;i<(data.length+1);i++) {
				state.options[i+1] = new Option(data[i].label,data[i].value);
				<c:if test='<%= Validator.isNotNull(customer) %>'>
					var regionId = '<%= regionId %>';
					console.log("regionId"+regionId);
					if (data[i].value == regionId) {
						state.options[i+1].setAttribute("selected", "selected");
					}
				</c:if>
			}
		}
	} 
</script>