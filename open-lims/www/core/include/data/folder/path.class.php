<?php
/**
 * @package data
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
require_once("interfaces/path.interface.php");

/**
 * Path Class
 * @package data
 */
class Path implements PathInterface
{
	const SEPARATOR = "/";

	private $path;
	private $path_array;

	/**
	 * @see PathInterface::__construct()
	 * @param string $path
	 */
	function __construct($path)
	{
		if ($path)
		{
			$this->path = $path;
			$this->path_array = explode(self::SEPARATOR,$path);
		}
		else
		{
			$this->path = null;
		}
	}
	
	function __destruct()
	{
		unset($this->path);
		unset($this->path_array);
	}

	/**
	 * @see PathInterface::get_path_string()
	 * @return string
	 */
	public function get_path_string()
	{
		if(is_array($this->path_array))
		{
			$return_value = null;
			
			foreach($this->path_array as $key => $value)
			{
				if ($return_value == null)
				{
					$return_value = $value;
				}
				else
				{
					$return_value .= self::SEPARATOR."".$value;
				}
			}
			return $return_value;
		}
		else
		{
			return null;
		}
	}

	/**
	 * @see PathInterface::get_path_elements()
	 * @return array
	 */
	public function get_path_elements()
	{
		return $this->path_array;
	}
	
	/**
	 * @see PathInterface::get_path_length()
	 * @return integer
	 */
	public function get_path_length()
	{
		return count($this->path_array)-1;
	}
	
	/**
	 * @see PathInterface::get_last_element()
	 * @return string
	 */
	public function get_last_element()
	{
		return $this->path_array[$this->get_path_length()];
	}
	
	/**
	 * @see PathInterface::replace_element_position()
	 * @param string $replace
	 * @param integer $position
	 * @return bool
	 */
	public function replace_element_position($replace, $position)
	{
		$replaced = false;
		
		for ($i=0;$i<=$this->get_path_length();$i++)
		{
			if ($i == $position)
			{
				$this->path_array[$i] = $replace;
				$replaced = true;
			}
		}
		return $replaced;
	}
	
	/**
	 * @see PathInterface::add_element()
	 * @param string $name
	 * @return bool
	 */
	public function add_element($name)
	{
		if ($name and $this->path_array)
		{
			array_push($this->path_array, $name);
			return true;
		}
		else
		{
			return false;
		}
	}

}
?>