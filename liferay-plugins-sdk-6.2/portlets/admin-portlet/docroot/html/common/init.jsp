<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@page import="java.util.List"%>
<%@page import="javax.portlet.PortletURL"%>

<%@page import="com.liferay.portal.model.Address"%>
<%@page import="com.liferay.portal.model.Phone"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.model.Contact"%>
<%@page import="com.liferay.portal.model.Country"%>
<%@page import="com.liferay.portal.model.Company"%>
<%@page import="com.liferay.portal.model.Organization"%>
<%@page import="com.liferay.portal.model.ListType"%>
<%@page import="com.liferay.portal.model.ListTypeConstants"%>
<%@page import="com.liferay.portal.kernel.util.TextFormatter"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.service.CountryServiceUtil"%>
<%@page import="com.liferay.portal.service.ListTypeServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.service.CompanyLocalServiceUtil"%>

<%@page import="com.msd.util.CommonUtil"%>
<%@page import="com.msd.slayer.model.Agent"%>
<%@page import="com.msd.slayer.model.Customer"%>
<%@page import="com.msd.slayer.service.CustomerLocalServiceUtil"%>
<%@page import="com.msd.slayer.service.AgentLocalServiceUtil"%>


<script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="https://cdn.datatables.net/1.10.11/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.11/css/jquery.dataTables.min.css">

<portlet:defineObjects />
<theme:defineObjects/>