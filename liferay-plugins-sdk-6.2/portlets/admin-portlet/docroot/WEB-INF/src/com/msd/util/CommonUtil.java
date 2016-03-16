package com.msd.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.Address;
import com.liferay.portal.model.Contact;
import com.liferay.portal.model.ListType;
import com.liferay.portal.model.ListTypeConstants;
import com.liferay.portal.model.Organization;
import com.liferay.portal.model.OrganizationConstants;
import com.liferay.portal.model.Phone;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroupRole;
import com.liferay.portal.model.Website;
import com.liferay.portal.service.AddressLocalServiceUtil;
import com.liferay.portal.service.ListTypeServiceUtil;
import com.liferay.portal.service.OrganizationLocalServiceUtil;
import com.liferay.portal.service.PhoneLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.UserGroupRoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.WebsiteLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;

public class CommonUtil {
	
	private static final Log _log = LogFactoryUtil.getLog(CommonUtil.class);
	
	public static DateFormat dateMonthYearFormat = new SimpleDateFormat("MM/dd/yyyy");
	
	public static int getListTypeId(List<ListType> listTypes,String type) {
		
		int typeId = 0;
		for (ListType listType: listTypes) {
			if (listType.getName().equalsIgnoreCase(type)) {
				typeId = listType.getListTypeId();
				break;
			}
		}
		_log.info("Type ID :: "+typeId);
		return typeId;
	}
	
	public static User getOrgAdmin(long organizationId) {
		
		_log.info("In getOrgAdmin ..");
		User orgAdmin = null;
		Organization organization = null;
		try {
			organization = OrganizationLocalServiceUtil.fetchOrganization(organizationId);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		if (Validator.isNull(organization)) return orgAdmin;
		
		List<User> orgUsers = null;
		List<UserGroupRole> UserGroupRole = null;
		try {
			orgUsers = UserLocalServiceUtil.getOrganizationUsers(organization.getOrganizationId());
			UserGroupRole = UserGroupRoleLocalServiceUtil.getUserGroupRolesByGroupAndRole(organization.getGroupId(),
					getRoleId(organization.getCompanyId(), RoleConstants.ORGANIZATION_ADMINISTRATOR));
		} catch (SystemException e) {
			e.printStackTrace();
		}

		if (Validator.isNotNull(orgUsers) && orgUsers.size() > 0) {
			for (User orgUser : orgUsers) {
				if (Validator.isNotNull(UserGroupRole) && UserGroupRole.size() > 0) {
					for (UserGroupRole usergroupRole : UserGroupRole) {
						if (orgUser.getUserId() == usergroupRole.getUserId()) {
							orgAdmin = orgUser;
						}
					}
				}
			}
		}
		
		return orgAdmin;
	}
	
	public static long getRoleId(long companyId, String name) {
		
		_log.info("In getRoleId ..");
		long roleId = 0;
		try {
			Role role = RoleLocalServiceUtil.getRole(companyId, name);
			roleId = role.getRoleId();
		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}
		return roleId;
	}
	
	public static Organization getOrganization(long organizationId) {
	
		_log.info("In getOrganization ..");
		Organization organization = null;
		try {
			organization = OrganizationLocalServiceUtil.fetchOrganization(organizationId);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		return organization;
	}
	
	@SuppressWarnings("unchecked")
	public static List<Phone> getPhoneNumberByClassNameAdClassPK(long classPK, int typeId, long companyId, String className) {
		
		_log.info("In getPhoneNumberByClassNameAdClassPK ..");
		List<Phone> phoneList = new ArrayList<Phone>();
		DynamicQuery dynamicQuery = null;
		try {
			dynamicQuery = DynamicQueryFactoryUtil.forClass(Phone.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq("classPK", classPK));
			dynamicQuery.add(RestrictionsFactoryUtil.eq("classNameId", getClassNameId(className)));  
			dynamicQuery.add(RestrictionsFactoryUtil.eq("typeId", typeId)); 
			phoneList = PhoneLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		return phoneList;
	}
	
	public static Phone getPhoneByTypeId(long classPK, long companyId, String type) {
		
		int typeId = 0;
		Phone phone = null;
		String className = StringPool.BLANK;
		List<ListType> listType = null;
		try {
			if (type.equals("phone")) {
				className = User.class.getName();
				listType = ListTypeServiceUtil.getListTypes(Contact.class.getName() + ListTypeConstants.ADDRESS);
				typeId = getListTypeId(listType, "Other");
			} else if (type.equals("fax")) {
				className = User.class.getName();
				listType = ListTypeServiceUtil.getListTypes(Contact.class.getName() + ListTypeConstants.PHONE);
				typeId = getListTypeId(listType, "business-fax");
			} else if (type.equals("toll-free")) {
				className = Organization.class.getName();
				listType = ListTypeServiceUtil.getListTypes(Organization.class.getName()+ ListTypeConstants.PHONE);
				typeId = getListTypeId(listType, "toll-free");
			}
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		List<Phone> phoneList = getPhoneNumberByClassNameAdClassPK(classPK, typeId, companyId, className);
	
		if (Validator.isNotNull(phoneList) && phoneList.size()>0) {
			phone = phoneList.get(0);
		}
		return phone;
	}
	
	public static long getClassNameId(String className) {
		return PortalUtil.getClassNameId(className);
	}
	
	public static Website getWebsiteByClassNameNClassPK(long companyId ,long classPK, String className) {
		
		_log.info("In getWebsiteByClassNameNClassPK ..");
		Website _website = null;
		List<Website>  websites = new ArrayList<Website>();
		try {
			websites = WebsiteLocalServiceUtil.getWebsites(companyId, className, classPK);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		if (Validator.isNotNull(websites) && websites.size() > 0) {
			Website website = websites.get(0);
			_website = website;
		}
		
		return _website;
	}
	
	public static String getCompanyWebsite(long companyId ,long classPK, String className) {
		
		_log.info("In getCompanyWebsite ..");
		Website website = getWebsiteByClassNameNClassPK(companyId, classPK, className);
		return (Validator.isNotNull(website) ? website.getUrl() :StringPool.BLANK);
	}
	
	public static long getWebsiteId(long companyId ,long classPK, String className) {
		
		_log.info("In getCompanyWebsite ..");
		Website website = getWebsiteByClassNameNClassPK(companyId, classPK, className);
		return (Validator.isNotNull(website) ? website.getWebsiteId() :0);
	}
	
	@SuppressWarnings("unchecked")
	public static Address getAddress(long classPK, String className) {
		
		_log.info("In getAddress ..");
		Address address = null;
		List<Address> addressList = new ArrayList<Address>();
		DynamicQuery dynamicQuery = null;
		try {
			dynamicQuery = DynamicQueryFactoryUtil.forClass(Address.class);
			dynamicQuery.add(RestrictionsFactoryUtil.eq("classPK", classPK));
			dynamicQuery.add(RestrictionsFactoryUtil.eq("classNameId", getClassNameId(className)));  
			addressList = AddressLocalServiceUtil.dynamicQuery(dynamicQuery);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		
		if (Validator.isNotNull(addressList) && addressList.size() > 0) {
			for (Address _address :addressList) {
				address = _address;
			}
		}
		
		return address;
	}
	
	public static User addUpdateUser(int salutation, long userId, long creatorUserId, long companyId, 
			String firstName, String lastName, String title, String email, String cmd,
			long[] orgId,  ServiceContext serviceContext, Locale locale)
			throws PortalException, SystemException {
		
		_log.info("In addUpdateUser ..");
		User user = null;
		if (cmd.equals(Constants.ADD)) {
			user = UserLocalServiceUtil.addUser(creatorUserId, companyId, true, StringPool.BLANK, StringPool.BLANK, 
					true, StringPool.BLANK, email, 0l, StringPool.BLANK, locale, firstName,
					StringPool.BLANK ,lastName, salutation, 0, true, 0, 1, 1970,
					title, null, orgId , null, null, true, serviceContext);
		} else {
			user = UserLocalServiceUtil.fetchUser(userId);
			user.setFirstName(firstName);
			user.setLastName(lastName);
			user.setEmailAddress(email);
			user.setJobTitle(title);
			user.setModifiedDate(new Date());  
			user = UserLocalServiceUtil.updateUser(user);
		}
		
		return user;
	}

	public static Organization addOrganization(long organizationId, long companyId, long websiteId, 
			ThemeDisplay themeDisplay, String orgName, String companyWebsite, String comments, String cmd, 
			ServiceContext serviceContext) {
		
		_log.info("In addOrganization .."); 
		Organization organization = null;
		try {
			List<ListType> websiteType = ListTypeServiceUtil.getListTypes(Organization.class.getName()+ListTypeConstants.WEBSITE);
			int websiteTypeId = CommonUtil.getListTypeId(websiteType, "Public");
			if (cmd.equals(Constants.ADD)) {
				
				organization = OrganizationLocalServiceUtil.addOrganization(themeDisplay.getUserId(), 
						OrganizationConstants.DEFAULT_PARENT_ORGANIZATION_ID, orgName, OrganizationConstants.TYPE_REGULAR_ORGANIZATION, 
						0l, 0l, ListTypeConstants.ORGANIZATION_STATUS_DEFAULT, comments, false, serviceContext);
				
				WebsiteLocalServiceUtil.addWebsite(themeDisplay.getUserId(), Organization.class.getName(), 
						organizationId, companyWebsite, websiteTypeId, true, serviceContext);
			} else {
				organization = getOrganization(organizationId);
				organization = OrganizationLocalServiceUtil.updateOrganization(organization.getCompanyId(), organizationId, OrganizationConstants.DEFAULT_PARENT_ORGANIZATION_ID,
						orgName, OrganizationConstants.TYPE_REGULAR_ORGANIZATION, 0l, 0l, ListTypeConstants.ORGANIZATION_STATUS_DEFAULT, comments, false, serviceContext);
				
				WebsiteLocalServiceUtil.updateWebsite(websiteId, companyWebsite, websiteTypeId, true);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return organization;
	}

	public static void addUpdateAddress(int typeId, long creatorUserId, long classPK,long countryId,
			long regionId, long addressId, String addr1, String addr2, String city, String postcode, String cmd, 
			ServiceContext serviceContext) throws PortalException, SystemException {
		
		_log.info("In addUpdateAddress .."); 
		Address address = null;
		if (cmd.equals(Constants.ADD)) {
			address = AddressLocalServiceUtil.addAddress(creatorUserId, User.class.getName(), 
					classPK, addr1, addr2, StringPool.BLANK,
					city, postcode, regionId, countryId, typeId, true, true, serviceContext);
		} else {
			address = AddressLocalServiceUtil.updateAddress(addressId, addr1, addr2, StringPool.BLANK, 
					city, postcode, regionId, countryId, typeId, true, true);
		}
		
		_log.info("address added/updated ::"+(Validator.isNotNull(address))); 
	}

	public static void addUpdatePhone(int typeId, long creatorId, long classPK, long phoneId, String number, String className, String cmd,
			ServiceContext serviceContext)
			throws PortalException, SystemException {
		
		_log.info("In addUpdatePhone .."); 
		if (cmd.equals(Constants.ADD)) {
			PhoneLocalServiceUtil.addPhone(creatorId, className, 
					classPK, number, StringPool.BLANK, typeId, true, serviceContext);
		} else {
			PhoneLocalServiceUtil.updatePhone(phoneId, number, StringPool.BLANK, typeId, true);
		}
	}
	
	public static void assignOrganizationAdminRole(Organization organization,
			String cmd, User user) {
		
		_log.info("In assignOrganizationAdminRole .."); 
		if (cmd.equals(Constants.ADD)) {
			try {
				Role role = RoleLocalServiceUtil.getRole(organization.getCompanyId(), RoleConstants.ORGANIZATION_ADMINISTRATOR);
				long[] addUserIds = new long[]{ user.getUserId()};
				UserGroupRoleLocalServiceUtil.addUserGroupRoles(addUserIds, organization.getGroup().getGroupId(), role.getRoleId());
			} catch (PortalException e) {
				e.printStackTrace();
			} catch (SystemException e) {
				e.printStackTrace();
			}
		}
	}

}
