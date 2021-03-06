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
 * Proejct User Data Access Class
 * @package project
 */
class ProjectUserData_Access
{
	private $user_id;
	private $quota;
	
	/**
	 * @param integer $user_id
	 */
	function __construct($user_id)
	{
		global $db;
		
		if ($user_id == null)
		{
			$this->user_id = null;
		}
		else
		{
			$sql = "SELECT * FROM ".constant("PROJECT_USER_DATA_TABLE")." WHERE user_id='".$user_id."'";
			$res = $db->db_query($sql);
			$data = $db->db_fetch_assoc($res);
			
			if ($data['user_id'])
			{
				$this->user_id	= $user_id;
				$this->quota	= $data['quota'];
			}
			else
			{
				$this->user_id 	= null;
			}
		}
	}
	
	function __destruct()
	{
		if ($this->id)
		{
			unset($this->user_id);
			unset($this->quota);
		}	
	}
	
	/**
	 * @param integer $user_id
	 * @param integer $quota
	 * @return bool
	 */
	public function create($user_id, $quota)
	{
		global $db;
		
		if (is_numeric($user_id) and is_numeric($quota))
		{
			$sql_write = "INSERT INTO ".constant("PROJECT_USER_DATA_TABLE")." (user_id,quota) " .
					"VALUES (".$user_id.",".$quota.")";
					
			$res_write = $db->db_query($sql_write);	
			
			if ($db->db_affected_rows($res_write) == 1)
			{
				return true;
			}
			else
			{
				return false;
			}	
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * @return bool
	 */
	public function delete()
	{
		global $db;
	
		if ($this->user_id)
		{
			$user_id_tmp = $this->user_id;
			
			$this->__destruct();
			
			$sql = "DELETE FROM ".constant("PROJECT_USER_DATA_TABLE")." WHERE user_id = ".$user_id_tmp."";
			$res = $db->db_query($sql);
			
			if ($db->db_affected_rows($res) == 1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * @return integer
	 */
	public function get_quota()
	{
		if ($this->quota)
		{
			return $this->quota;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @param integer $quota
	 * @return bool
	 */
	public function set_quota($quota)
	{
		global $db;
			
		if ($this->user_id and is_numeric($quota))
		{
			$sql = "UPDATE ".constant("PROJECT_USER_DATA_TABLE")." SET quota = '".$quota."' WHERE user_id = ".$this->user_id."";
			$res = $db->db_query($sql);
			
			if ($db->db_affected_rows($res))
			{
				$this->quota = $quota;
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
}
?>