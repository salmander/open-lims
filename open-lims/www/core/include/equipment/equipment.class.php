<?php
/**
 * @package equipment
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
require_once("interfaces/equipment.interface.php");

if (constant("UNIT_TEST") == false or !defined("UNIT_TEST"))
{
	require_once("access/equipment.access.php");
	require_once("access/equipment_is_item.access.php");
}

/**
 * Equipment Category Management Class
 * @package equipment
 */
class Equipment extends Item implements EquipmentInterface, EventListenerInterface, ItemListenerInterface
{
	private $equipment_id;
	private $equipment;
	
	/**
	 * @see EquipmentInterface::__construct()
	 * @param integer $equipment_id
	 * @throws EquipmentNotFoundException
	 */
	function __construct($equipment_id)
	{
		if (is_numeric($equipment_id))
		{
			if (Equipment_Access::exist_id($equipment_id) == true)
			{
				$this->equipment_id = $equipment_id;
				$this->equipment = new Equipment_Access($equipment_id);
				
				$equipment_is_item = new EquipmentIsItem_Access($equipment_id);
				$this->item_id = $equipment_is_item->get_item_id();
	    		parent::__construct($this->item_id);
			}
			else
			{
				throw new EquipmentNotFoundException();
			}
		}
		else
		{
			$this->equipment_id = null;
			$this->equipment = new Equipment_Access(null);
			parent::__construct(null);
		}
	}
	
	public function __destruct()
   	{
   		
   	}
	
	/**
	 * @see EquipmentInterface::create()
	 * @param integer $type_id
	 * @param integer $owner_id
	 * @return integer
	 * @throws EquipmentCreateFailedException
	 * @throws EquipmentCreateAsItemException
	 * @throws EquipmentCreateIDMissingException
	 */
	public function create($type_id, $owner_id)
	{
		global $transaction;
		
		if (is_numeric($type_id) and is_numeric($owner_id))
		{		
			$transaction_id = $transaction->begin();
			
			try
			{
				if (($equipment_id = $this->equipment->create($type_id, $owner_id)) == null)
				{
					throw new EquipmentCreateFailedException();
				}
					
				$this->item_id = parent::create();
						
				$equipment_is_item = new EquipmentIsItem_Access(null);
				if ($equipment_is_item->create($equipment_id, $this->item_id) == false)
				{
					throw new EquipmentCreateAsItemException();
				}
			}
			catch(BaseException $e)
			{
				if ($transaction_id != null)
				{
					$transaction->rollback($transaction_id);
				}
				throw $e;
			}
			
			if ($transaction_id != null)
			{
				$transaction->commit($transaction_id);
			}
			
			self::__construct($equipment_id);
			
			return $equipment_id;
		}
		else
		{
			throw new EquipmentCreateIDMissingException();
		}
	}
	
	/**
	 * @see EquipmentInterface::delete()
	 * @return bool
	 * @throws EquipmentDeleteItemLinkException
	 * @throws EquipmentDeleteFailedException
	 * @throws EquipmentNoInstanceException
	 */
	public function delete()
	{
   		global $transaction;
   		
   		if ($this->equipment_id and $this->equipment)
		{
			$transaction_id = $transaction->begin();
			
			try
			{				
				parent::delete();
							
				$equipment_is_item = new EquipmentIsItem_Access($this->equipment_id);
				if ($equipment_is_item->delete() == false)
				{
					throw new EquipmentDeleteItemLinkException();
				}
			
				if ($this->equipment->delete() == false)
				{
					throw new EquipmentDeleteFailedException();
				}
			}
			catch(BaseException $e)
			{
				if ($transaction_id != null)
				{
					$transaction->rollback($transaction_id);
				}
				throw $e;
			}
			
			if ($transaction_id != null)
			{
				$transaction->commit($transaction_id);
			}
			return true;
		}
		else
		{
			throw new EquipmentNoInstanceException();
		}
	}
		
	/**
	 * @see EquipmentInterface::get_type_id()
	 * @return integer
	 */
	public function get_type_id()
	{
		if ($this->equipment_id and $this->equipment)
		{
			return $this->equipment->get_type_id();
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see EquipmentInterface::get_owner_id()
	 * @return integer
	 */
	public function get_owner_id()
	{
		if ($this->equipment_id and $this->equipment)
		{
			return $this->equipment->get_owner_id();
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see EquipmentInterface::get_datetime()
	 * @return string
	 */
	public function get_datetime()
	{
		if ($this->equipment_id and $this->equipment)
		{
			return $this->equipment->get_datetime();
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_item_parents()
	 * @return array
	 */
	public final function get_item_parents()
	{
		return null;
	}

	/**
	 * @see ItemListenerInterface::get_item_object_id()
	 * @return integer
	 */
	public final function get_item_object_id()
	{
		if ($this->equipment_id)
		{
			return $this->equipment_id;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_item_object_name()
	 * @return string
	 */
	public final function get_item_object_name()
	{
		if ($this->equipment_id and $this->equipment)
		{
			$equipment_type = new EquipmentType($this->equipment->get_type_id());
			return $equipment_type->get_name();
		}
		else
		{
			return null;
		}
	}
	
	
	/**
	 * @see EquipmentInterface::list_entries_by_user_id()
	 * @return array
	 */
	public static function list_entries_by_user_id($user_id)
	{
		return Equipment_Access::list_entries_by_owner_id($user_id);
	} 
	
	/**
	 * @see EquipmentInterface::list_entries_by_type_id()
	 * @param integer $type_id
	 * @return array
	 */
	public static function list_entries_by_type_id($type_id)
	{
		return Equipment_Access::list_entries_by_type_id($type_id);
	}
	
	/**
	 * @see ItemListenerInterface::clone_item()
	 * @param integer $item_id
	 * @return integer
	 */
	public static function clone_item($item_id)
	{
		global $user;
		
		if (is_numeric($item_id))
		{
			$equipment_id = self::get_entry_by_item_id($item_id);
			$current_equipment = new Equipment($equipment_id);
			$new_equipment = new Equipment(null);
			
			if ($new_equipment->create($current_equipment->get_type_id(), $user->get_user_id()) != null)
			{
				return $new_equipment->get_item_id();
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
	 * @see ItemListenerInterface::get_entry_by_item_id()
	 * @param integer $item_id
	 * @return integer
	 */
	public static function get_entry_by_item_id($item_id)
	{
		return EquipmentIsItem_Access::get_entry_by_item_id($item_id);
	}
	    
 	/**
 	 * @see ItemListenerInterface::is_kind_of()
     * @param string $type
     * @param integer $item_id
     * @return bool
     */
    public static function is_kind_of($type, $item_id)
    {
    	if (is_numeric($item_id))
    	{
    		if (($equipment_id = EquipmentIsItem_Access::get_entry_by_item_id($item_id)) != null)
    		{
    			return true;
    		}
    		else
    		{
    			return false;
    		}
    	}
    }
    
    /**
     * @see ItemListenerInterface::is_type_or_category()
     * @param integer $category_id
     * @param integer $type_id
     * @param integer $item_id
     * @return bool
     */
    public static function is_type_or_category($category_id, $type_id, $item_id)
    {
    	if (is_numeric($type_id))
    	{
    		$equpiment_id = EquipmentIsItem_Access::get_entry_by_item_id($item_id);
    		$equipment = new Equipment($equpiment_id);
    		
    		if ($equipment->get_type_id() == $type_id)
    		{
    			return true;
    		}
    		else
    		{
    			return false;
    		}
    	}
    	elseif (is_numeric($category_id))
    	{
    		$equipment_id = EquipmentIsItem_Access::get_entry_by_item_id($item_id);
    		$equipment = new Equipment($equipment_id);
    		$equipment_type = new SampleTtype($equipment->get_type_id());
    		
    		if ($equipment_type->get_cat_id() == $category_id)
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
     * @see ItemListenerInterface::get_instance_by_item_id()
     * @param integer $item_id
     * @param boolean $light_instance
     * @return object
     */
    public static function get_instance_by_item_id($item_id, $light_instance = false)
    {
    	if (is_numeric($item_id))
    	{
    		$equipment_id = EquipmentIsItem_Access::get_entry_by_item_id($item_id);
    		return new Equipment($equipment_id);
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see ItemListenerInterface::get_generic_name()
     * @param string $type
     * @param array $type_array
     * @return string
     */
    public static function get_generic_name($type, $type_array)
    {
    	return "Equipment";
    }
    
    /**
     * @see ItemListenerInterface::get_generic_symbol()
	 * @param string $type
	 * @param integer $id
	 * @return string
	 */
    public static function get_generic_symbol($type, $id)
    {
    	return "<img src='images/icons/equipment.png' alt='' style='border: 0;' />";
    }
    
    /**
     * @see ItemListenerInterface::get_generic_link()
	 * @param string $type
	 * @param integer $id
	 * @return string
	 */
	public static function get_generic_link($type, $id)
	{
		return null;
	}
    
	/**
	 * @see ItemListenerInterface::get_sql_select_array()
	 * @param string $type
	 * @return array
	 */
	public static function get_sql_select_array($type)
    {
    	$select_array['name'] = "".constant("EQUIPMENT_TYPE_TABLE").".name";
		$select_array['type_id'] = "".constant("EQUIPMENT_TYPE_TABLE").".id AS equipment_id";
		$select_array['datetime'] = "".constant("EQUIPMENT_TABLE").".datetime";
		return $select_array;
    }
    
    /**
     * @see ItemListenerInterface::get_sql_join()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_join($type)
	{
		return 	"LEFT JOIN ".constant("EQUIPMENT_IS_ITEM_TABLE")." 		ON ".constant("ITEM_TABLE").".id 						= ".constant("EQUIPMENT_IS_ITEM_TABLE").".item_id " .
				"LEFT JOIN ".constant("EQUIPMENT_TABLE")." 				ON ".constant("EQUIPMENT_IS_ITEM_TABLE").".equipment_id = ".constant("EQUIPMENT_TABLE").".id " .
				"LEFT JOIN ".constant("EQUIPMENT_TYPE_TABLE")." 		ON ".constant("EQUIPMENT_TABLE").".type_id 				= ".constant("EQUIPMENT_TYPE_TABLE").".id ";
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_where()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_where($type)
	{
		return "(LOWER(TRIM(".constant("EQUIPMENT_TYPE_TABLE").".name)) LIKE '{STRING}')";
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_select_array()
	 * @param string $type
	 * @return array
	 */
	public static function get_sql_fulltext_select_array($type)
	{
		return null;
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_join()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_fulltext_join($type)
	{
		return null;
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_where()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_fulltext_where($type)
	{
		return null;
	}
	
	/**
	 * @see ItemListenerInterface::get_item_add_dialog()
	 * @param string $item_type
	 * @return array
	 */
	public static function get_item_add_dialog($item_type)
	{
		return array(array("window"), "window");
	}
	
	/**
	 * ItemListenerInterface::get_item_add_occurrence()
	 * @param unknown_type $item_type
	 * @return array
	 */
	public static function get_item_add_occurrence($item_type)
	{
		return array(true, true, "deny");
	}
	
	/**
	 * @see ItemListenerInterface::get_item_add_script_handling_class()
	 * @param string $item_type
	 * @return array
	 */
	public static function get_item_add_script_handling_class($item_type)
	{
		return array("equipment/ajax/equipment.ajax.php", "EquipmentAjax", "add_as_item_window_init");
	}
	
    /**
     * @see EventListenerInterface::listen_events()
     * @param object $event_object
     * @return bool
     */
    public static function listen_events($event_object)
    {
    	if ($event_object instanceof UserDeletePrecheckEvent)
    	{
    		$equipment_array =  self::list_entries_by_user_id($event_object->get_user_id()); 
			
			if (is_array($equipment_array))
			{
				if (count($equipment_array) >= 1)
				{
					return false;
				}
			}
    	}
    	
    	if ($event_object instanceof ItemUnlinkEvent)
    	{
    		if (($equipment_id = EquipmentIsItem_Access::get_entry_by_item_id($event_object->get_item_id())) != null)
    		{
    			$equipment = new Equipment($equipment_id);
    			if ($equipment->delete() == false)
    			{
    				return false;
    			}	
    		}
    	}
    	
    	return true;
    }
}
?>