<?php
/**
 * @package base
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
 * Base Include File Access Class
 * @package base
 */
class BaseIncludeFile_Access
{
	const BASE_INCLUDE_FILE_PK_SEQUENCE = 'core_base_include_files_id_seq';
	
	private $id;
	private $include_id;
	private $name;
	private $checksum;
	
	/**
	 * @param integer $id
	 */
	function __construct($id)
	{
		global $db;
		
		if ($id == null)
		{
			$this->id = null;
		}
		else
		{
			$sql = "SELECT * FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE id='".$id."'";
			$res = $db->db_query($sql);
			$data = $db->db_fetch_assoc($res);
			
			if ($data['id'])
			{
				$this->id 			= $id;
				$this->include_id	= $data['include_id'];
				$this->name			= $data['name'];
				$this->checksum		= $data['checksum'];
			}
			else
			{
				$this->id			= null;
			}				
		}
	}
	
	function __destruct()
	{
		if ($this->id)
		{
			unset($this->id);
			unset($this->include_id);
			unset($this->name);
			unset($this->checksum);
		}
	}
	
	/**
	 * @param integer $include_id
	 * @param string $name
	 * @param string $checksum
	 * @return integer
	 */
	public function create($include_id, $name, $checksum)
	{
		global $db;

		if (is_numeric($include_id) and $name and $checksum)
		{
	 		$sql_write = "INSERT INTO ".constant("BASE_INCLUDE_FILE_TABLE")." (id, include_id, name, checksum) " .
								"VALUES (nextval('".self::BASE_INCLUDE_FILE_PK_SEQUENCE."'::regclass),'".$include_id."','".$name."','".$checksum."')";		
				
			$res_write = $db->db_query($sql_write);
			
			if ($db->db_affected_rows($res_write) == 1)
			{
				$sql_read = "SELECT id FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE id = currval('".self::BASE_INCLUDE_FILE_PK_SEQUENCE."'::regclass)";
				$res_read = $db->db_query($sql_read);
				$data_read = $db->db_fetch_assoc($res_read);
							
				self::__construct($data_read['id']);		
								
				return $data_read['id'];
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @return bool
	 */
	public function delete()
	{
		global $db;

		if ($this->id)
		{
			$id_tmp = $this->id;
			
			$this->__destruct();

			$sql = "DELETE FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE id = '".$id_tmp."'";
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
	 * @return integer;
	 */
	public function get_include_id()
	{
		if ($this->include_id)
		{
			return $this->include_id;
		}
		else
		{
			return null;
		}	
	}
	
	/**
	 * @return string;
	 */
	public function get_name()
	{
		if ($this->name)
		{
			return $this->name;
		}
		else
		{
			return null;
		}	
	}
	
	/**
	 * @return string;
	 */
	public function get_checksum()
	{
		if ($this->checksum)
		{
			return $this->checksum;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @param integer $include_id
	 * @return bool
	 */
	public function set_include_id($include_id)
	{
		global $db;

		if ($this->id and is_numeric($include_id))
		{
			$sql = "UPDATE ".constant("BASE_INCLUDE_FILE_TABLE")." SET include_id = '".$include_id."' WHERE id = ".$this->id."";
			$res = $db->db_query($sql);
			
			if ($db->db_affected_rows($res))
			{
				$this->include_id = $include_id;
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
	 * @param string $name
	 * @return bool
	 */
	public function set_name($name)
	{
		global $db;

		if ($this->id and $name)
		{
			$sql = "UPDATE ".constant("BASE_INCLUDE_FILE_TABLE")." SET name = '".$name."' WHERE id = ".$this->id."";
			$res = $db->db_query($sql);
			
			if ($db->db_affected_rows($res))
			{
				$this->name = $name;
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
	 * @param string $checksum;
	 * @return bool
	 */
	public function set_checksum($checksum)
	{
		global $db;

		if ($this->id and $checksum)
		{
			$sql = "UPDATE ".constant("BASE_INCLUDE_FILE_TABLE")." SET checksum = '".$checksum."' WHERE id = ".$this->id."";
			$res = $db->db_query($sql);
			
			if ($db->db_affected_rows($res))
			{
				$this->checksum = $checksum;
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
	 * @param integer $include_id
	 * @param string $name
	 * @return string
	 */
	public static function get_checksum_by_include_id_and_name($include_id, $name)
	{
		global $db;

		if (is_numeric($include_id) and $name)
		{
			$name = trim(strtolower($name));
			
			$sql = "SELECT checksum FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE include_id = '".$include_id."' AND TRIM(LOWER(name)) = '".$name."'";
			$res = $db->db_query($sql);
			$data = $db->db_fetch_assoc($res);
			
			if ($data['checksum'])
			{
				return $data['checksum'];
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @param integer $include_id
	 * @param string $name
	 * @return string
	 */
	public static function get_id_by_include_id_and_name($include_id, $name)
	{
		global $db;

		if (is_numeric($include_id) and $name)
		{
			$name = trim(strtolower($name));
			
			$sql = "SELECT id FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE include_id = '".$include_id."' AND TRIM(LOWER(name)) = '".$name."'";
			$res = $db->db_query($sql);
			$data = $db->db_fetch_assoc($res);
			
			if ($data['id'])
			{
				return $data['id'];
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @param integer $include_id
	 * @return bool
	 */
	public static function delete_by_include_id($include_id)
	{
		global $db;

		if (is_numeric($include_id))
		{
			$sql = "DELETE FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE include_id = '".$include_id."'";
			$res = $db->db_query($sql);
			
			if ($res !== false)
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
	 * @param integer $include_id
	 * @return bool
	 */
	public static function delete_by_include_id_and_name($include_id, $name)
	{
		global $db;

		if (is_numeric($include_id) and $name)
		{
			$sql = "DELETE FROM ".constant("BASE_INCLUDE_FILE_TABLE")." WHERE include_id = '".$include_id."' AND TRIM(name) = TRIM('".$name."')";
			$res = $db->db_query($sql);
			
			if ($res !== false)
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
}

?>