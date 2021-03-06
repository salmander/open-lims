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
 * User Rename Event
 * @package base
 */
class UserRenameEvent extends Event
{    
	private $user_id;
	
	function __construct($user_id)
    {
    	if (is_numeric($user_id))
    	{
    		parent::__construct();
    		$this->user_id = $user_id;
    	}
    	else
    	{
    		$this->user_id = null;
    	}
    }
    
    public function get_user_id()
    {
    	if ($this->user_id)
    	{
    		return $this->user_id;
    	}
    	else
    	{
    		return null;
    	}
    }
}

?>