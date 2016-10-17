<?php
/**
 * @package project
 * @version 0.4.0.0
 * @author Roman Konertz <konertz@open-lims.org>
 * @copyright (c) 2008-2014 by Roman Konertz
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
 * Project Data Search IO Class
 * @package project
 */
class ProjectDataSearchIO
{
	/**
	 * @param integer $language_id
	 */
	public static function get_description($language_id)
	{
		return "Finds Data in Projects uncoupled to Folder-structure.";
	}
	
	public static function get_icon()
	{
		return "images/icons_large/data_search_50.png";
	}
	
	/**
	 * @todo search on read-only projects
	 */
	public static function search()
	{
		global $user, $session;
		
		if ($_GET['nextpage'])
		{
			if ($_GET['sortvalue'] and $_GET['sortmethod'])
			{
				if ($_GET['nextpage'] == "2" and $_POST['string'])
				{
					$string = $_POST['string'];
					$item_type_array = $session->read_value("SEARCH_DATA_ITEM_TYPE");
					$project_id_array = $session->read_value("SEARCH_DATA_PROJECT_ID");
				}
				else
				{
					$string = $session->read_value("SEARCH_DATA_STRING");
					$item_type_array = $session->read_value("SEARCH_DATA_ITEM_TYPE");
					$project_id_array = $session->read_value("SEARCH_DATA_PROJECT_ID");
				}
			}
			else
			{
				if ($_GET['page'])
				{
					$string = $session->read_value("SEARCH_DATA_STRING");
					$item_type_array = $session->read_value("SEARCH_DATA_ITEM_TYPE");
					$project_id_array = $session->read_value("SEARCH_DATA_PROJECT_ID");
				}
				else
				{
					if ($_GET['nextpage'] == "1")
					{
						$string = $_POST['string'];
						$session->delete_value("SEARCH_DATA_STRING");
						$session->delete_value("SEARCH_DATA_ITEM_TYPE");
						$session->delete_value("SEARCH_DATA_PROJECT_ID");
					}
					else
					{
						$string = $_POST['string'];
						$item_type_array = $session->read_value("SEARCH_DATA_ITEM_TYPE");
						$project_id_array = $session->read_value("SEARCH_DATA_PROJECT_ID");
					}
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
			$template = new HTMLTemplate("project/search/data_search.html");
			
			$template->set_var("error", "");
			
			$paramquery = $_GET;
			unset($paramquery['page']);
			$paramquery['nextpage'] = "1";
			$params = http_build_query($paramquery,'','&#38;');
					
			$template->set_var("params",$params);
				
			$result = array();
			$counter = 0;
							
			$project_array = Project::list_user_related_projects($user->get_user_id(), false);
			
			if (is_array($project_array) and count($project_array) >= 1)
			{
				foreach($project_array as $key => $value)
				{
					$project = new Project($value);
					$organisation_unit = new OrganisationUnit($project->get_organisation_unit_id());
				
					$result[$counter]['value'] = $value;
					$result[$counter]['content'] = $project->get_name()." (".$organisation_unit->get_name().")";		
					$result[$counter]['selected'] = "";
		
					$counter++;
				}
			}
			
			$template->set_var("project_array",$result);
			
			
			$result = array();
			$counter = 0;
			$item_type_array = Item::list_types();
			
			if (is_array($item_type_array))
			{
				foreach($item_type_array as $key => $value)
				{
					if (class_exists($value))
					{
						if ($value::get_sql_select_array($key) != null)
						{
							$result[$counter]['title'] = $value::get_generic_name($key, null);
							$result[$counter]['name'] = "item-".$key;
							$result[$counter]['value'] = $key;
							$result[$counter]['checked'] = "checked='checked'";
							
							$counter++;
						}
					}
				}
			}
			
			$template->set_var("item_type_array",$result);
			
			$template->output();
		}
		else
		{
			if(!$project_id_array)
			{	
				if ($_POST['project_id'] == 0)
				{
					$project_id_array = array();
					$tmp_id_array = Project::list_user_related_projects($user->get_user_id(), false);
					if (is_array($tmp_id_array) and count($tmp_id_array) >= 1)
					{
						foreach($tmp_id_array as $key => $value)
						{
							array_push($project_id_array, $value);
						}
					}
				}
				else
				{
					$project_id_array = array();
					$project_id_array[0] = $_POST['project_id'];
					$project = new Project($_POST['project_id']);
					$search_name = $project->get_name();
				}
			}
			else
			{
				if (count($project_id_array) == 1)
				{
					$project = new Project($project_id_array[0]);
					$search_name = $project->get_name();
				}
				else
				{
					$search_name = "All";
				}
			}
			
			if(!$item_type_array)
			{
				$item_type_array = array();
				
				foreach($_POST as $key => $value)
				{
					if (strpos($key, "item-") === 0)
					{
						array_push($item_type_array, $value);
					}
				}
				
				if (!$item_type_array)
				{
					$tmp_item_type_array = Item::list_types();
					foreach($tmp_item_type_array as $key => $value)
					{
						if (class_exists($value))
						{
							if ($value::get_sql_select_array($key) != null)
							{
								array_push($item_type_array, $key);
							}
						}
					}
				}
			}
			
			$session->write_value("SEARCH_DATA_STRING", $string, true);
			$session->write_value("SEARCH_DATA_ITEM_TYPE", $item_type_array, true);
			$session->write_value("SEARCH_DATA_PROJECT_ID", $project_id_array, true);

			
			$argument_array = array();
			$argument_array[0][0] = "string";
			$argument_array[0][1] = $string;
			$argument_array[1][0] = "project_id_array";
			$argument_array[1][1] = $project_id_array;
			$argument_array[2][0] = "item_type_array";
			$argument_array[2][1] = $item_type_array;

			$list = new List_IO("ProjectDataSearch", "ajax.php?nav=project", "search_project_data_list_projects", "search_project_data_count_projects", $argument_array, "ProjectDataSearch");

			$list->add_column("", "symbol", false, "16px");
			$list->add_column(Language::get_message("ProjectGeneralListColumnName", "general"), "name", true, null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnType", "general"), "type", false, null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnDateTime", "general"), "datetime", true, null);
			$list->add_column(Language::get_message("ProjectGeneralListColumnProject", "general"), "project_name", true, null);
			
			$template = new HTMLTemplate("project/search/data_search_result.html");
		
			$paramquery = $_GET;
			$paramquery['nextpage'] = "2";
			$params = http_build_query($paramquery,'','&#38;');
			
			$template->set_var("params", $params);
			
			$template->set_var("string", $string);
				
			$template->set_var("list", $list->get_list());	
	
			$template->output();
		}
	}
}
