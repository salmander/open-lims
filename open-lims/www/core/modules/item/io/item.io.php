<?php
/**
 * @package item
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
 * Item IO Class
 * @package item
 */
class ItemIO
{
	/**
	 * @param string $link
	 * @param string $description
	 * @param string $keywords
	 */
	public static function information($link, $description, $keywords)
	{
		$template = new HTMLTemplate("item/information.html");
		
		$template->set_var("link", $link);
		
		if (!$_POST['description'] and $_POST['submitbutton'] == "next" and $description == true)
		{
			$template->set_var("error","You must enter a description!");	
		}
		elseif (!$_POST['keywords'] and $_POST['submitbutton'] == "next" and $keywords)
		{
			$template->set_var("error","You must enter keywords!");		
		}
		else
		{
			$template->set_var("error",false);		
		}
		
		if ($_POST['description'])
		{
			$template->set_var("description_value",$_POST['description']);	
		}
		else
		{
			$template->set_var("description_value","");	
		}
		
		if ($_POST['keywords'])
		{
			$template->set_var("keywords_value",$_POST['keywords']);	
		}
		else
		{
			$template->set_var("keywords_value","");	
		}
		
		if ($description == true)
		{
			$template->set_var("description",true);
		}
		else
		{
			$template->set_var("description",false);
		}
		
		if ($keywords)
		{
			$template->set_var("keywords",true);
		}
		else
		{
			$template->set_var("keywords",false);
		}
		
		$template->output();	
	}	
}

?>
