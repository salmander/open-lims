<?php 
/**
 * @package project
 * @version 0.4.0.0
 * @author Roman Konertz <konertz@open-lims.org>
 * @copyright (c) 2008-2016 by Roman Konertz
 * @license GPLv3
 * 
 * This file is part of Open-LIMS
 * Available at http://www.open-lims.org
 * 
 * This program is free software;
 * you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation;
 * version 3 of the License.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program;
 * if not, see <http://www.gnu.org/licenses/>.
 */

/**
 * 
 */
	$dialog[0]['type']				= "parent_item_list";
	$dialog[0]['class_path']		= "core/modules/project/io/project.io.php";
	$dialog[0]['class']				= "ProjectIO";
	$dialog[0]['method']			= "list_projects_by_item_id";
	$dialog[0]['internal_name']		= "project";
	$dialog[0]['language_address']	= "ProjectDialogParentItemProjectList";
	$dialog[0]['weight']			= 100;
	
	$dialog[1]['type']				= "search";
	$dialog[1]['class_path']		= "core/modules/project/io/project_search.io.php";
	$dialog[1]['class']				= "ProjectSearchIO";
	$dialog[1]['method']			= "search";
	$dialog[1]['internal_name']		= "project_search";
	$dialog[1]['language_address']	= "ProjectDialogProjectSearch";
	$dialog[1]['weight']			= 100;
	
	$dialog[2]['type']				= "search";
	$dialog[2]['class_path']		= "core/modules/project/io/project_data_search.io.php";
	$dialog[2]['class']				= "ProjectDataSearchIO";
	$dialog[2]['method']			= "search";
	$dialog[2]['internal_name']		= "project_data_search";
	$dialog[2]['language_address']	= "ProjectDialogProjectDataSearch";
	$dialog[2]['weight']			= 300;
	
	$dialog[3]['type']				= "module_admin";
	$dialog[3]['class_path']		= "core/modules/project/io/admin/admin_project_status.io.php";
	$dialog[3]['class']				= "AdminProjectStatusIO";
	$dialog[3]['method']			= "handler";
	$dialog[3]['internal_name']		= "project_status";
	$dialog[3]['language_address']	= "ProjectDialogAdminMenuProjectStatus";
	$dialog[3]['weight']			= 1000;
	
	$dialog[4]['type']				= "module_admin";
	$dialog[4]['class_path']		= "core/modules/project/io/admin/admin_project_template_cat.io.php";
	$dialog[4]['class']				= "AdminProjectTemplateCatIO";
	$dialog[4]['method']			= "handler";
	$dialog[4]['internal_name']		= "Project_template_cat";
	$dialog[4]['language_address']	= "ProjectDialogAdminMenuProjectTemplateCat";
	$dialog[4]['weight']			= 1100;
	
	$dialog[5]['type']				= "module_admin";
	$dialog[5]['class_path']		= "core/modules/project/io/admin/admin_project_template.io.php";
	$dialog[5]['class']				= "AdminProjectTemplateIO";
	$dialog[5]['method']			= "handler";
	$dialog[5]['internal_name']		= "project_template";
	$dialog[5]['language_address']	= "ProjectDialogAdminMenuProjectTemplate";
	$dialog[5]['weight']			= 1200;
	
	$dialog[6]['type']				= "user_module_detail_setting";
	$dialog[6]['class_path']		= "core/modules/project/io/project_data.io.php";
	$dialog[6]['class']				= "ProjectDataIO";
	$dialog[6]['method']			= "get_user_module_detail_setting";
	$dialog[6]['internal_name']		= "project_quota";
	$dialog[6]['language_address']	= "ProjectDialogModuleDetailProjectQuota";
	$dialog[6]['weight']			= 200;
	
	$dialog[7]['type']				= "module_value_change";
	$dialog[7]['class_path']		= "core/modules/project/io/project_data.io.php";
	$dialog[7]['class']				= "ProjectDataIO";
	$dialog[7]['method']			= "change";
	$dialog[7]['internal_name']		= "project_quota";
	$dialog[7]['language_address']	= "ProjectDialogModuleValueProjectQuota";
	
	$dialog[8]['type']				= "additional_quota";
	$dialog[8]['class_path']		= "core/modules/project/io/project_data.io.php";
	$dialog[8]['class']				= "ProjectDataIO";
	$dialog[8]['method']			= "get_used_project_space";
	$dialog[8]['internal_name']		= "project_quota";
	$dialog[8]['language_address']	= "ProjectDialogAdditionalQuota";
	$dialog[8]['weight']			= 100;
	
	$dialog[9]['type']				= "home_today_box";
	$dialog[9]['class_path']		= "core/modules/project/io/project_task.io.php";
	$dialog[9]['class']				= "ProjectTaskIO";
	$dialog[9]['method']			= "list_upcoming_tasks";
	$dialog[9]['internal_name']		= "project_tasks";
	$dialog[9]['weight']			= 100;
	
	$dialog[10]['type']				= "base_left_navigation";
	$dialog[10]['class_path']		= "core/modules/project/io/navigation/project_navigation.io.php";
	$dialog[10]['class']			= "ProjectNavigationIO";
	$dialog[10]['method']			= "get_html";
	$dialog[10]['internal_name']	= "projects";
	$dialog[10]['language_address']	= "ProjectDialogLeftNavigation";
	$dialog[10]['weight']			= 300;
	
	$dialog[11]['type']				= "item_parent_assistant_list";
	$dialog[11]['class_path']		= "core/modules/project/io/project.io.php";
	$dialog[11]['class']			= "ProjectIO";
	$dialog[11]['method']			= "list_projects_by_item_id";
	$dialog[11]['internal_name']	= "project";
	$dialog[11]['weight']			= 100;
	
	$dialog[12]['type']				= "home_summary_left";
	$dialog[12]['class_path']		= "core/modules/project/io/project_home.io.php";
	$dialog[12]['class']			= "ProjectHomeIO";
	$dialog[12]['method']			= "running_projects";
	$dialog[12]['internal_name']	= "project";
	$dialog[12]['weight']			= 100;
	
	$dialog[13]['type']				= "home_summary_left";
	$dialog[13]['class_path']		= "core/modules/project/io/project_home.io.php";
	$dialog[13]['class']			= "ProjectHomeIO";
	$dialog[13]['method']			= "finished_projects";
	$dialog[13]['internal_name']	= "project";
	$dialog[13]['weight']			= 200;
	
	$dialog[14]['type']				= "standard_search";
	$dialog[14]['class_path']		= "core/modules/project/io/project_search.io.php";
	$dialog[14]['class']			= "ProjectSearchIO";
	$dialog[14]['method']			= "search";
	$dialog[14]['internal_name']	= "project_search";
?>