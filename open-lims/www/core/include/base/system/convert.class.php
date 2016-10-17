<?php
/**
 * @package base
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
 * 
 */
require_once("interfaces/convert.interface.php");

/**
 * Convert Class
 * @package base
 */
class Convert implements ConvertInterface
{
	/**
	 * @see ConvertInterface::convert_byte_1024()
	 * @param integer $byte
	 * @return string
	 */
	public static function convert_byte_1024($byte)
	{
		global $regional;
		
		if ($byte == 0)
		{
		 	$act_filesize = "0&nbsp;Byte";
		}else
		{
		 	$tmp_filesize = floor($byte/1024);
		 	
		 	if ($tmp_filesize == 0)
		 	{
		 		$act_filesize = $regional->format_number($byte)."&nbsp;Byte";
		 	}
		 	else
		 	{
		 		$tmp_filesize = floor($tmp_filesize/1024);
		 		
		 		if ($tmp_filesize == 0)
		 		{
		 			$rounder = $byte/1024;
		 			$act_filesize = $regional->format_number($rounder,2)."&nbsp;KiB";
		 		}
		 		else
		 		{
		 			$tmp_filesize = floor($tmp_filesize/1024);
		 			if ($tmp_filesize == 0) 
		 			{
		 			
		 				$rounder = $byte/1048576;
		 				$act_filesize = $regional->format_number($rounder,2)."&nbsp;MiB";
		 			}
		 			else
		 			{
		 				$tmp_filesize = floor($tmp_filesize/1024);
		 				if ($tmp_filesize == 0)
		 				{
		 					$rounder = $byte/1073741824;
		 					$act_filesize = $regional->format_number($rounder,2)."&nbsp;GiB";
		 				}
		 				else
		 				{
		 					$tmp_filesize = floor($tmp_filesize/1024);
		 					$rounder = $byte/1099511627776;
		 					$act_filesize = $regional->format_number($rounder, 2)."&nbsp;TiB";	
		 				}
		 			}
		 		}
		 	}
		 }

		 return $act_filesize;
	}

}

?>