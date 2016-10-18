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
 * Project Search IO Class
 * @package project
 */
class ProjectSearchIO
{
	/**
	 * @return string
	 */
	public static function get_description($language_id)
	{
		return "Finds Projects in Organisation Units via Name and/or Template.";
	}
	
	/**
	 * @return string
	 */
	public static function get_icon()
	{
		return "images/icons_large/project_search_50.png";
	}
	
	public static function search()
	{
		global $user, $session;
		
		if ($_GET['nextpage'])
		{
			if ($_GET['page'] or $_GET['sortvalue'] or $_GET['sortmethod'])
			{
				$name = $session->read_value("SEARCH_PROJECT_NAME");
				$organisation_unit_array = $session->read_value("SEARCH_PROJECT_ORGANISATION_UNIT_ARRAY");
				$template_array = $session->read_value("SEARCH_PROJECT_TEMPLATE_ARRAY");
			}
			else
			{
				if ($_GET['nextpage'] == "1")
				{
					$name = $_POST['string'];
					$session->delete_value("SEARCH_PROJECT_NAME");
					$session->delete_value("SEARCH_PROJECT_ORGANISATION_UNIT_ARRAY");
					$session->delete_value("SEARCH_PROJECT_TEMPLATE_ARRAY");
				}
				else
				{
					$name = $_POST['string'];
					$organisation_unit_array = $session->read_value("SEARCH_PROJECT_ORGANISATION_UNIT_ARRAY");
					$template_array = $session->read_value("SEARCH_PROJECT_TEMPLATE_ARRAY");
				}
			}
			$no_error = true;
		}
		else
		{
			$no_error = false;
		}
		
		if ($no_error == false)
		{
			$template = new HTMLTemplate("project/search/search.html");
			
			$paramquery = $_GET;
			unset($paramquery['page']);
			$paramquery['nextpage'] = "1";
			$params = http_build_query($paramquery,'','&#38;');
					
			$template->set_var("params",$params);
			
			$template->set_var("error", "");
			
			$result = array();
			$counter = 0;
			
			$organisation_unit_array = OrganisationUnit::list_entries();
			
			if (is_array($organisation_unit_array) and count($organisation_unit_array) >= 1)
			{
				foreach($organisation_unit_array as $key => $value)
				{
					$organisation_unit = new OrganisationUnit($value);
			
					if ($organisation_unit->is_permission($user->get_user_id()))
					{
						$result[$counter]['value'] = $value;
						$result[$counter]['content'] = $organisation_unit->get_name();		
						$result[$counter]['selected'] = "";
		
						$counter++;
					}
				}
			}
			
			if (!$result)
			{
				$result[$counter]['value'] = "0";
				$result[$counter]['content'] = "NO ORGANISATION UNIT FOUND!";	
			}
			
			$template->set_var("organ_unit",$result);
			
			
			$result = array();
			$counter = 0;
				
			$project_template_array = ProjectTemplateCat::list_entries();
			
			if (is_array($project_template_array))
			{
				foreach($project_template_array as $key => $value)
				{
					$project_template_cat = new ProjectTemplateCat($value);	
					$result[$counter]['value'] = "";
					$result[$counter]['content'] = $project_template_cat->get_name();		
					$result[$counter]['selected'] = "";
	
					$counter++;
					
					$project_template_sub_array = ProjectTemplate::list_entries_by_cat_id($value);
					
					if (is_array($project_template_sub_array))
					{
						foreach($project_template_sub_array as $sub_key => $sub_value)
						{
							$project_sub_template = new ProjectTemplate($sub_value);
	
							
							$result[$counter]['value'] = $sub_value;
							$result[$counter]['content'] = "&nbsp;".$project_sub_template->get_name();		
							$result[$counter]['selected'] = "";
			
							$counter++;
						}
					}
					unset($project_template_sub_array);
				}
			}
			else
			{
				$result[$counter]['value'] = "0";
				$result[$counter]['content'] = "NO TEMPLATES FOUND!";
			}
	
			$template->set_var("template",$result);
					
			$template->output();	
		}
		else
		{
			if(!$organisation_unit_array)
			{			
				if (!$_POST['organisation_unit'])
				{
					$organisation_unit_array = array();
					
					$organisation_unit_array = OrganisationUnit::list_entries();
					
					if (is_array($organisation_unit_array) and count($organisation_unit_array) >= 1)
					{
						foreach($organisation_unit_array as $key => $value)
						{
							$organisation_unit = new OrganisationUnit($value);
							if ($organisation_unit->is_permission($user->get_user_id()))
							{
								array_push($organisation_unit_array, $value);
							}
						}
					}
					$search_organisation_unit_name = "All";
				}
				else
				{
					$organisation_unit_array = array();
					$organisation_unit_array[0] = $_POST['organisation_unit'];
					$organisation_unit = new OrganisationUnit($_POST['organisation_unit']);
					$search_organisation_unit_name = $organisation_unit->get_name();
				}
			}
			else
			{
				if (count($organisation_unit_array) == 1)
				{
					$organisation_unit = new OrganisationUnit($organisation_unit_array[0]);
					$search_organisation_unit_name = $organisation_unit->get_name();
				}
				else
				{
					$search_organisation_unit_name = "All";
				}
			}
			
			if (!$template_array)
			{
				if (!$_POST['template'])
				{
					$template_array = null;
					$search_template_name = "All";
				}
				else
				{
					$template_array = array();
					$template_array[0] = $_POST['template'];
					$project_template = new ProjectTemplate($_POST['template']);
					$search_template_name = $project_template->get_name();
				}
			}
			else
			{
				if (count($template_array) == 1)
				{
					$project_template = new ProjectTemplate($template_array[0]);
					$search_template_name = $project_template->get_name();
				}
				else
				{
					$search_template_name = "All";
				}
			}
			
			$session->write_value("SEARCH_PROJECT_NAME", $name, true);
			$session->write_value("SEARCH_PROJECT_ORGANISATION_UNIT_ARRAY", $organisation_unit_array, true);
			$session->write_value("SEARCH_PROJECT_TEMPLATE_ARRAY", $template_array, true);
			
			/* --------------- */
			
			
			$argument_array = array();
			$argument_array[0][0] = "name";
			$argument_array[0][1] = $name;
			$argument_array[1][0] = "template_array";
			$argument_array[1][1] = $template_array;
			$argument_array[2][0] = "organisation_unit_array";
			$argument_array[2][1] = $organisation_unit_array;
		
			$list = new List_IO("ProjectSearch", "ajax.php?nav=project", "search_project_list_projects", "search_project_count_projects", $argument_array, "ProjectSearch");
		
			$list->add_column("","symbol",false,"16px");
			$list->add_column(Language::get_message("ProjectGeneralListColumnName", "general"),"name",true,null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnOrganisationUnit", "general"),"organisation_unit",true,null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnDateTime", "general"),"datetime",true,null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnTemplate", "general"),"template",true,null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnStatus", "general"),"status",true,null);
			
			
			$template = new HTMLTemplate("project/search/search_result.html");
			
			$paramquery = $_GET;
			$paramquery['nextpage'] = "2";
			unset($paramquery['page']);
			unset($paramquery['sortvalue']);
			unset($paramquery['sortmethod']);
			$params = http_build_query($paramquery,'','&#38;');
			
			$template->set_var("params", $params);
			
			$template->set_var("name", $name);
			$template->set_var("organisation_units", $search_organisation_unit_name);
			$template->set_var("templates", $search_template_name);
				
			$template->set_var("list", $list->get_list());
	
			$template->output();
		}
	}
}

?>