<?php
/**
 * @package sample
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
require_once("interfaces/sample.interface.php");

if (constant("UNIT_TEST") == false or !defined("UNIT_TEST"))
{
	require_once("events/sample_delete_event.class.php");
	
	require_once("access/sample.access.php");
	require_once("access/sample_is_item.access.php");
	require_once("access/sample_has_location.access.php");
	require_once("access/sample_has_organisation_unit.access.php");
	require_once("access/sample_has_user.access.php");
}

/**
 * Sample Management Class
 * @package sample
 */
class Sample extends Item implements SampleInterface, EventListenerInterface, ItemListenerInterface, ItemHolderListenerInterface
{
	private $sample;
	
	private $sample_id;
	
	private $template_data_type;
	private $template_data_type_id;
	private $template_data_array;

	private $sample_folder_id;
	private $sample_folder_object;
	
	private static $sample_delete_array = array();
	
	/**
	 * @see SampleInterface::__construct()
	 * @param integer $sample_id Sample-ID
	 * @throws SampleNotFoundException
	 */
    function __construct($sample_id)
    {
    	if (is_numeric($sample_id))
		{
			if (Sample_Access::exist_sample_by_sample_id($sample_id) == true)
			{
				$this->sample_id = $sample_id;
	    		$this->sample = new Sample_Access($sample_id);
	    		
	    		$sample_is_item = new SampleIsItem_Access($sample_id);
	    		$this->item_id = $sample_is_item->get_item_id();
	    		parent::__construct($this->item_id);
			}
			else
			{
				if (in_array($sample_id, self::$sample_delete_array) == false)
				{
					throw new SampleNotFoundException();
				}
			}
		}
		else
		{
			$this->sample_id = null;
    		$this->sample = new Sample_Access(null);
    		parent::__construct(null);
		}
    }
    
    function __destruct()
    {
    	if ($this->sample_id)
    	{
    		unset($this->sample_id);
    		unset($this->sample);
    	}
    	else
    	{
    		unset($this->sample);
    	}
    }
    
    /**
     * @see SampleInterface::set_template_data()
     * @param string $type
     * @param integer $type_id
     * @param array $array
     * @return bool
     */
    public function set_template_data($type, $type_id, $array)
    {
    	if (($type == "sample" or $type == "value") and is_array($array))
    	{
    		$this->template_data_type = $type;
    		$this->template_data_type_id = $type_id;
    		$this->template_data_array = $array;
    		return true;
    	}
    	else
    	{
    		return false;
    	} 	
    }
    
    /**
     * @param string $transaction_id
     * @param integer $sample_id
     * @param integer $template_id
     * @return mixed
     * @throws SampleCreateFolderException
     * @throws SampleCreateSubFolderException
     */
    private function create_sample_folder($sample_id, $template_id)
    {
    	global $user, $transaction;
    	
    	if ($transaction->is_in_transction() and is_numeric($sample_id) and is_numeric($template_id))
    	{
	    	// Create Sample Folder
	    	$base_folder_id = constant("SAMPLE_FOLDER_ID");
			$base_folder = Folder::get_instance($base_folder_id);
	
			$path = new Path($base_folder->get_path());
			$path->add_element($sample_id);
					
			$sample_folder = new SampleFolder(null);
			if (($folder_id = $sample_folder->create($sample_id)) == null)
			{
				$sample_folder->delete(true, true);
				throw new SampleCreateFolderException("Could not create main folder");
			}
			$folder = Folder::get_instance($folder_id);

			// Create Subfolders
			$sub_folder_name_array = array();
    		$sample_template = new SampleTemplate($template_id);
	    			
    		$folder_array = array();
    		$requirement_array = $sample_template->get_requirements();
    			
    		if (is_array($requirement_array) and count($requirement_array) >= 1)
    		{
    			foreach($requirement_array as $key => $value)
    			{
    				if ($value['folder'])
    				{
						if (!in_array($value['folder'], $folder_array))
						{
							array_push($folder_array, $value['folder']);
						}
    				}
    			}	
    				
    			if (is_array($folder_array) and count($folder_array) >= 1)
    			{
    				foreach($folder_array as $key => $value)
    				{
    					$folder_name = strtolower(trim($value));
    					$folder_name = str_replace(" ","-",$folder_name);
		
						$folder_path = new Path($folder->get_path());
						$folder_path->add_element($folder_name);

						$sub_folder = Folder::get_instance(null);
						if (($sub_folder_id = $sub_folder->create($value, $folder_id, $folder_path->get_path_string(), $user->get_user_id(), null)) == null)
						{
							$sample_folder->delete(true, true);
							throw new SampleCreateSubFolderException("Could not create sub folder");
						}
						
						$sub_folder_name_array[$sub_folder_id] = strtolower(trim($value));
    				}
    			}
    		}
    		
    		$this->sample_folder_id = $folder_id;
    		$this->sample_folder_object = $sample_folder;
    		
    		return $sub_folder_name_array;
    	}
    	else
    	{
    		throw new SampleCreateFolderException("Could not create main folder");
    	}
    }
    
    /**
     * @param string $transaction_id
     * @param integer $sample_id
     * @return bool
     * @throws SampleCreateAsItemException
     */
    private function create_sample_item($sample_id)
    {
    	global $transaction;
    	
    	if ($transaction->is_in_transction() and is_numeric($sample_id))
    	{
    		// Create Item
			$this->item_id = parent::create();
				
    		$sample_is_item = new SampleIsItem_Access(null);
			if ($sample_is_item->create($sample_id, $this->item_id) == false)
			{
				throw new SampleCreateAsItemException();
			}
			
			return true;
    	}
    	else
    	{
    		throw new SampleCreateAsItemException();
    	}
    }
    
    /**
     * @see SampleInterface::create()
     * @todo sample adding via template required field via item_id
     * @param integer $organisation_unit_id
     * @param integer $template_id
     * @param string $name
     * @param string $supplier
     * @param integer $location_id
     * @param string $desc
     * @return integer Sample-ID
     * @throws SampleCreateFailedException
     * @throws SampleCreateIDMissingException
     * @throws SampleCreateFolderException
     * @throws SampleCreateSubFolderException
     * @throws SampleCreateAsItemException
     * @throws SampleCreateUserException
     * @throws SampleCreateOrganisationUnitException
     * @throws SampleCreateLocationException
     * @throws SampleCreateItemSampleException
     * @throws SampleCreateItemValueException
     */
    public function create($organisation_unit_id, $template_id, $name, $manufacturer_id, $location_id, $desc, $language_id, $date_of_expiry, $expiry_warning)
    {    	
    	global $user, $transaction;
    	
    	if ($this->sample and is_numeric($template_id) and $name)
    	{
    		$transaction_id = $transaction->begin();
    		
    		try
			{
	    		if (($sample_id = $this->sample->create($name, $user->get_user_id(), $template_id, $manufacturer_id, $desc, $language_id, $date_of_expiry, $expiry_warning)) == null)
	    		{
	    			throw new SampleCreateFailedException();
	    		}
    		
				if ($desc)
				{
					$this->sample->set_comment_text_search_vector($desc, "english");
				}

				$this->create_sample_folder($sample_id, $template_id);
				$this->create_sample_item($sample_id);
	
    			
    			// Create Permissions and V-Folders
    			$sample_security = new SampleSecurity($sample_id);
    		
    			if ($sample_security->create_user($user->get_user_id(), true, true) == null)
    			{
					throw new SampleCreateUserException();
    			}
    			
    			if (is_numeric($organisation_unit_id))
    			{
    				if ($sample_security->create_organisation_unit($organisation_unit_id) == null)
    				{
						throw new SampleCreateOrganisationUnitException();
    				}
    			}    			
    			
    			if (is_numeric($location_id) and $location_id > 0)
    			{
	    			// Create First Location
	    			$sample_has_locaiton_access = new SampleHasLocation_Access(null);
	    			if ($sample_has_locaiton_access->create($sample_id, $location_id, $user->get_user_id()) == null)
	    			{
						throw new SampleCreateLocationException("Could not create first location");
	    			}
    			}
	
				// Create Required Value or Sample
				if (is_array($this->template_data_array) and count($this->template_data_array) >= 1)
				{
					if ($this->template_data_type == "sample")
					{
						foreach($this->template_data_array as $key => $value)
						{
							if ($value > 0)
							{
								if (SampleItemFactory::create($value, $this->item_id, null, null, null) == false)
								{
									throw new SampleCreateItemSampleException();
								}
							}
						}
					}
					
					if ($this->template_data_type == "value")
					{
						$value = Value::get_instance(null);				
						if ($value->create($this->sample_folder_id, $user->get_user_id(), $this->template_data_type_id, $this->template_data_array) == null)
						{
							throw new SampleCreateItemValueException();
						}
						
						$sample_item = new SampleItem($sample_id);
													
						$sample_item->set_item_id($value->get_item_id());
						
						if ($sample_item->link_item() == false)
						{
							throw new SampleCreateItemValueException();
						}
					}
				}
	    	}
			catch(BaseException $e)
			{
				if(is_object($this->sample_folder_object))
				{
					$this->sample_folder_object->delete(true, true);
				}
				
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

			self::__construct($sample_id);
			
    		return $sample_id;	
    	}
    	else
    	{
    		throw new SampleCreateIDMissingException();
    	}
    }
    
    /**
     * @see SampleInterface::clone_sample()
     * @param integer $source_sample_id
     * @param string $name
     * @param integer $manufacturer_id
     * @param integer $location_id
     * @param string $desc
     * @param integer $language_id
     * @param string $date_of_expiry
     * @param integer $expiry_warning
     * @param array $value_array
     * @param array $item_array
     * @return integer
     * @throws SampleCloneIDMissingException
     * @throws SampleCloneCreateException
     * @throws SampleCloneCreateFolderException
     * @throws SampleCloneCreateSubFolderException
     * @throws SampleCloneCreateAsItemException
     * @throws SampleCloneCreateLocationException
     * @throws SampleCloneCreateFailedException
     * @throws SampleCloneUserException
     * @throws SampleCloneOrganisationUnitException
     * @throws SampleCloneLocationException
     * @throws SampleCloneValueException
     * @throws SampleCloneFileException
     * @throws SampleCloneParentException
     * @throws SampleCloneItemException
     */
    public function clone_sample($source_sample_id, $name, $manufacturer_id, $location_id, $desc, $language_id, $date_of_expiry, $expiry_warning, $value_array, $item_array)
    {
    	global $user, $transaction;
    	
    	if (is_numeric($source_sample_id) and $name)
    	{
    		$source_sample = new Sample($source_sample_id);
    		$source_sample_security = new SampleSecurity($source_sample_id);
    		$source_sample_folder_id = SampleFolder::get_folder_by_sample_id($source_sample_id);
    		
    		$transaction_id = $transaction->begin();
    		
    		try
			{
	    		if (($sample_id = $this->sample->create($name, $user->get_user_id(), $source_sample->get_template_id(), $manufacturer_id, $desc, $language_id, $date_of_expiry, $expiry_warning)) == null)
	    		{
	    			throw new SampleCloneCreateFailedException();
	    		}
	    		
    			if ($desc)
				{
					$this->sample->set_comment_text_search_vector($desc, "english");
				}
   
	    		$sub_folder_name_array = $this->create_sample_folder($sample_id, $source_sample->get_template_id());
	    		$this->create_sample_item($sample_id);
    			
	    		$sample_security = new SampleSecurity($sample_id);
				
				$source_sample_user_list = $source_sample_security->list_users();
				
				if (is_array($source_sample_user_list) and count($source_sample_user_list) >= 1)
				{
					foreach($source_sample_user_list as $key => $value)
					{
						if ($sample_security->create_user($value, true, true) == null)
		    			{
							throw new SampleCloneUserException();
		    			}
					}
				}
				
				$source_sample_organisation_list = $source_sample_security->list_organisation_units();
				
				if (is_array($source_sample_organisation_list) and count($source_sample_organisation_list) >= 1)
				{
					foreach($source_sample_organisation_list as $key => $value)
					{
						if ($sample_security->create_organisation_unit($value) == null)
	    				{
							throw new SampleCloneOrganisationUnitException();
	    				}
					}
				}
				
				
				// Locations
				$source_sample_location_array = SampleHasLocation_Access::list_entries_by_sample_id($source_sample_id);
				$end_sample_has_location_access = new SampleHasLocation_Access(end($source_sample_location_array));
				
				if (is_array($source_sample_location_array) and count($source_sample_location_array) >= 1)
				{
					if ($location_id != $end_sample_has_location_access->get_location_id())
					{
						$add_new_location = true;
					}
					else
					{
						$add_new_location = false;
					}
					
					foreach ($source_sample_location_array as $key => $value)
					{
						$current_sample_has_location_access = new SampleHasLocation_Access($value);
						$sample_has_location_access = new SampleHasLocation_Access(null);
		    			if ($sample_has_location_access->create($sample_id, $current_sample_has_location_access->get_location_id(), $user->get_user_id()) == null)
		    			{
							throw new SampleCloneLocationException();
		    			}
					}
				}
				else
				{
					$add_new_location = true;
				}
				
    			if (is_numeric($location_id) and $add_new_location == true and $location_id > 0)
    			{
	    			// Create First Location
	    			$sample_has_location_access = new SampleHasLocation_Access(null);
	    			if ($sample_has_location_access->create($sample_id, $location_id, $user->get_user_id()) == null)
	    			{
						throw new SampleCloneCreateLocationException("Could not create location");
	    			}
    			}
    			
    			if (is_array($value_array) and count($item_array) >= 1)
    			{
    				$value_item_array = array();
    				$value_data_array = array();
    				
    				foreach($value_array as $key => $value)
    				{
    					$key = str_replace("value-","",$key);
    					$key_array = explode("-", $key, 2);
    					
    					if ($key_array[0] == "item")
    					{
    						$value_item_array[$key_array[1]] = $value;
    					}
    					elseif(is_numeric($key_array[0]))
    					{
    						$value_data_array[$key_array[0]][$key_array[1]] = $value;
    					}
    				}
    				
    				if (is_array($value_item_array) and count($value_item_array) >= 1)
    				{
    					foreach ($value_item_array as $key => $value)
    					{
    						$gid = SampleItem::get_gid_by_item_id_and_sample_id($value, $source_sample_id);
    						$data_entity_id = DataEntity::get_entry_by_item_id($value);
    						$value_id = Value::get_value_id_by_data_entity_id($data_entity_id);
    						if (is_numeric($value_id))
    						{
    							$value_obj = Value::get_instance($value_id);
    							$parent_folder_id = $value_obj->get_parent_folder_id();
    							$value_type_id = $value_obj->get_type_id();
    							
    							if ($parent_folder_id == $source_sample_folder_id)
    							{
    								$new_folder_id = $this->sample_folder_id;
    							}
    							else
    							{
    								$folder_name = Folder::get_name_by_id($parent_folder_id);
    								$new_folder_id = array_search(trim(strtolower($folder_name)),$sub_folder_name_array);
    							}
    							
    							if (is_numeric($new_folder_id) and is_numeric($value_type_id))
    							{
    								$new_value_obj = Value::get_instance(null);
    								
    								$new_value_obj->create($new_folder_id, $user->get_user_id(), $value_type_id, $value_data_array[$key]);
    								
    								$new_value_item_id = $new_value_obj->get_item_id();
    								
    								$sample_item = new SampleItem($sample_id);
    								$sample_item->set_gid($gid);
    								
    								if ($sample_item->set_item_id($new_value_item_id) == false)
    								{
										throw new SampleCloneValueException();
    								}
    								
    								if ($sample_item->link_item() == false)
    								{
										throw new SampleCloneValueException();
    								}
    							}
    						}
    					}
    				}
    			}
    			

    			if (is_array($item_array) and count($item_array) >= 1)
    			{
    				$item_type_array = array();
    				$item_data_array = array();
    				
    				foreach($item_array as $key => $value)
    				{
    					if ($value[1] == "1")
    					{
    						$item_explode_array = explode("-", $value[0], 2);
    						
    						if (!in_array($item_explode_array[0], $item_type_array))
    						{
    							array_push($item_type_array, $item_explode_array[0]);
    						}
    						if (!is_array($item_data_array[$item_explode_array[0]]))
    						{
    							$item_data_array[$item_explode_array[0]] = array();
    						}
    						array_push($item_data_array[$item_explode_array[0]], $item_explode_array[1]);
    					}
    				}
    				
    				if (is_array($item_type_array) and count($item_type_array) >= 1)
    				{
    					foreach($item_type_array as $key => $value)
    					{
    						if ($value == "parent")
    						{
    							foreach($item_data_array[$value] as $data_key => $data_value)
	    						{
	    							$parent_item_explode_array = explode("-", $data_value, 2);
	    							
	    							if ($parent_item_explode_array[0] and $parent_item_explode_array[1])
	    							{
							  			$item_add_holder_event = new ItemAddHolderEvent($parent_item_explode_array[1], $parent_item_explode_array[0], $this->item_id);
										$event_handler = new EventHandler($item_add_holder_event);
											
										if ($event_handler->get_success() == false)
										{
											throw new SampleCloneParentException();
										}
	    							}
	    						}
    						}
    						elseif ($value == "file")
    						{
    							if (is_array($item_data_array[$value]) and count($item_data_array[$value]) >= 1)
    							{
    								foreach($item_data_array[$value] as $data_key => $data_value)
	    							{
			    						$gid = SampleItem::get_gid_by_item_id_and_sample_id($data_value, $source_sample_id);
	    								
	    								$data_entity_id = DataEntity::get_entry_by_item_id($data_value);
		    							$file_id = File::get_file_id_by_data_entity_id($data_entity_id);
		    							
		    							if ($file_id)
		    							{
			    							$file_obj = File::get_instance($file_id);
			    							$parent_folder_id = $file_obj->get_parent_folder_id();
			    							    							
			    							if ($parent_folder_id == $source_sample_folder_id)
			    							{
			    								$new_folder_id = $this->sample_folder_id;
			    							}
			    							else
			    							{
			    								$folder_name = Folder::get_name_by_id($parent_folder_id);
			    								$new_folder_id = array_search(trim(strtolower($folder_name)),$sub_folder_name_array);
			    							}
			    							
			    							if (is_numeric($new_folder_id))
			    							{
			    								if ($file_obj->copy($new_folder_id) == false)
			    								{
													throw new SampleCloneFileException();
			    								}
			    								
			    								$new_file_item_id = $file_obj->get_item_id();
			    								
			    								$sample_item = new SampleItem($sample_id);
			    								$sample_item->set_gid($gid);
			    								
			    								if ($sample_item->set_item_id($new_file_item_id) == false)
			    								{
													throw new SampleCloneFileException();
			    								}
			    								
			    								if ($sample_item->link_item() == false)
			    								{
													throw new SampleCloneFileException();
			    								}
			    							}
		    							}
	    							}
    							}
    						}
    						else
    						{
    							if (is_array($item_data_array[$value]) and count($item_data_array[$value]) >= 1)
    							{
    								$handling_class = Item::get_handling_class_by_type($value);
    								
    								if ($handling_class)
    								{
	    								foreach($item_data_array[$value] as $data_key => $data_value)
	    								{
	    									$gid = SampleItem::get_gid_by_item_id_and_sample_id($data_value, $source_sample_id);
	    									
	    									$new_item_id = $handling_class::clone_item($data_value);
	    									
	    									if ($new_item_id)
	    									{
	    										$sample_item = new SampleItem($sample_id);
	    										$sample_item->set_gid($gid);
	    										
			    								if ($sample_item->set_item_id($new_item_id) == false)
			    								{
													throw new SampleCloneItemException();
			    								}
			    								
			    								if ($sample_item->link_item() == false)
			    								{
													throw new SampleCloneItemException();
			    								}
	    									}
	    								}
    								}
    							}
    						}
    					}
    				}
    			}
			}
			catch(BaseException $e)
			{
				if(is_object($this->sample_folder_object))
				{
					$this->sample_folder_object->delete(true, true);
				}
				
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

			self::__construct($sample_id);
			
    		return $sample_id;	
    	}
    	else
    	{
    		throw new SampleCloneIDMissingException();
    	}
    }
    
	/**
	 * @see SampleInterface::delete()
	 * @return bool
	 * @throws SampleDeleteLocationException
	 * @throws SampleDeleteUserException
	 * @throws SampleDeleteOrganisationUnitException
	 * @throws SampleDeleteItemException
	 * @throws SampleDeleteFolderException
	 * @throws SampleDeleteEventFailedException
	 * @throws SampleDeleteFailedException
	 * @throws SampleDeleteItemLinkException
	 * @throws SampleNoInstanceException
	 */
	public function delete()
	{
		global $transaction;
		
		if ($this->sample_id and $this->sample)
		{
			$transaction_id = $transaction->begin();
			
			try
			{
				array_push(self::$sample_delete_array, $this->sample_id);
				
				$tmp_sample_id = $this->sample_id;
			
				// Location Relations
				$sample_has_location_array = SampleHasLocation_Access::list_entries_by_sample_id($tmp_sample_id);
				if (is_array($sample_has_location_array) and count($sample_has_location_array) >= 1)
				{
					foreach($sample_has_location_array as $key => $value)
					{
						$sample_has_location = new SampleHasLocation_Access($value);
						if ($sample_has_location->delete() == false)
						{
							throw new SampleDeleteLocationException();
						}
					}
				}
				
				// Organisation Unit and User Relations
				$sample_security = new SampleSecurity($tmp_sample_id);
				$organisation_unit_array = $sample_security->list_organisation_unit_entries();
				if (is_array($organisation_unit_array) and count($organisation_unit_array) >= 1)
				{
					foreach($organisation_unit_array as $key => $value)
					{
						if ($sample_security->delete_organisation_unit($value) == false)
						{
							throw new SampleDeleteOrganisationUnitException();
						}
					}
				}
							
				$user_array = $sample_security->list_user_entries();
				if (is_array($user_array) and count($user_array) >= 1)
				{
					foreach($user_array as $key => $value)
					{
						if ($sample_security->delete_user($value) == false)
						{
							throw new SampleDeleteUserException();
						}
					}
				}
				
				// Items
				$sample_item = new SampleItem($tmp_sample_id);
				$item_array = $sample_item->get_sample_items();
				if (is_array($item_array) and count($item_array) >= 1)
				{
					foreach($item_array as $item_key => $item_value)
					{
						$sample_item = new SampleItem($tmp_sample_id);
						$sample_item->set_item_id($item_value);
						if ($sample_item->unlink_item() == false)
						{
							throw new SampleDeleteItemException();
						}
					}
				}	
				
				// Parent-Sample-Sub-Item-Links
				if (SampleItem::delete_remaining_sample_entries($tmp_sample_id) == false)
				{
					throw new SampleDeleteItemException();
				}
				
				parent::delete();
	    		
				$sample_delete_event = new SampleDeleteEvent($tmp_sample_id);
				$event_handler = new EventHandler($sample_delete_event);
	
				if ($event_handler->get_success() == false)
				{
					throw new SampleDeleteEventFailedException();
				}
				
				$sample_is_item = new SampleIsItem_Access($tmp_sample_id);
				if ($sample_is_item->delete() == false)
				{
					throw new SampleDeleteItemLinkException();
				}
				
				if ($this->sample->delete() == false)
				{
					throw new SampleDeleteFailedException();
				}
				else
				{
					$this->__destruct();
		    		$folder_id = SampleFolder::get_folder_by_sample_id($tmp_sample_id);
		    		$folder = Folder::get_instance($folder_id);
		    		if ($folder->delete(true, true) == false)
		    		{
						throw new SampleDeleteFolderException();
		    		}
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
			throw new SampleNoInstanceException();
		}	
	}
	
	/**
	 * @see SampleInterface::get_requirements()
	 * @param boolean $get_fulfilled
	 * @return array
	 */
    public function get_requirements($get_fulfilled = true)
    {
    	global $runtime_data;
    	
    	if ($this->sample_id and $this->sample)
    	{
    		if ($runtime_data->is_object_data($this, "SAMPLE_".$this->sample_id."_REQUIREMENT_ARRAY") == true)
	    	{
	    		return $runtime_data->read_object_data($this, "SAMPLE_".$this->sample_id."_REQUIREMENT_ARRAY");
	    	}
	    	else
	    	{
		    	$sample_template 		= new SampleTemplate($this->sample->get_template_id());
		    	
		    	$requirements_array 	= $sample_template->get_requirements();
				
				$return_array = array();
				$parent_item_array = array();
				$counter = 0;
				$type_counter = 0;
				$category_counter = 0;
				$fulfilled_counter = 0;
				$filter_counter = 0;
				$sub_item_counter = 0;
	
				if (is_array($requirements_array) and count($requirements_array) >= 1)
				{
					if ($runtime_data->is_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY") == true)
		    		{
						$item_type_array = $runtime_data->read_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY");
		    		}
		    		else
		    		{
		    			$item_type_array = Item::list_types();
		    			$runtime_data->write_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY", $item_type_array);	
		    		}
		    		
		    		if ($runtime_data->is_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY") == true)
		    		{
		    			$item_array = $runtime_data->read_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY");
		    		}
		    		else
		    		{
		    			$sample_item = new SampleItem($this->sample_id);
						$item_array = $sample_item->get_sample_items_with_pos_id();
						$runtime_data->write_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY", $item_array);	
		    		}
						
					foreach($requirements_array as $key => $value)
					{
						if ($value['xml_element'] == "item" and !$value['close'])
						{
							$in_item = true;
							
							$return_array[$counter]['element_type'] = "item";		
							$return_array[$counter]['display'] = true;
								
							$return_array[$counter]['type'] = $value['type'];
							$return_array[$counter]['name'] = $value['name'];
							$return_array[$counter]['dialog'] = $value['dialog'];
							$return_array[$counter]['handling_class'] = Item::get_handling_class_by_type($value['type']);
							
							$return_array[$counter]['requirement'] = $value['requirement'];
	
							if ($value['occurrence'])
							{
								$return_array[$counter]['occurrence'] = $value['occurrence'];
							}
							else
							{
								$return_array[$counter]['occurrence'] = "once";
							}
							
							if ($value['pos_id'])
							{
								$pos_id = $value['pos_id'];
								$return_array[$counter]['pos_id'] = $value['pos_id'];
							}
							else
							{
								$pos_id = $counter;
								$return_array[$counter]['pos_id'] = $counter;
							}
							
							
							if ($value['type'] != "parentsample")
							{
								if (is_array($item_array) and count($item_array) >= 1)
								{	
									$item_instance_array = array();
			
									foreach($item_array as $item_key => $item_value)
									{
										if (is_array($item_type_array) and count($item_type_array) >= 1)
										{
											foreach ($item_type_array as $item_type => $item_handling_class)
											{
												if (class_exists($item_handling_class))
												{
													if ($item_handling_class::is_kind_of($item_type, $item_value['item_id']) == true and $item_value['pos_id'] == $pos_id and $item_value['pos_id'] !== null and $pos_id !== null)
													{
														$item_instance = $item_handling_class::get_instance_by_item_id($item_value['item_id'], true);
														$return_array[$counter]['fulfilled'][$fulfilled_counter]['item_id'] = $item_value['item_id'];
														$return_array[$counter]['fulfilled'][$fulfilled_counter]['id'] = $item_instance->get_item_object_id();
														$return_array[$counter]['fulfilled'][$fulfilled_counter]['name'] = $item_instance->get_item_object_name();
														$item_instance_array[$fulfilled_counter] = $item_instance;
														$fulfilled_counter++;
														break;
													}
												}
											}
										}
									}
									
									if ($value['inherit'] == "all" or $force_inherit == true)
									{									
										if (is_array($item_instance_array) and count($item_instance_array) >= 1 and $fulfilled_counter >= 1)
										{
											foreach($item_instance_array as $object_key => $object_value)
											{
												if (is_object($object_value))
												{	
													if ($object_value instanceof ItemHolderInterface)
													{	
														$return_array[$counter]['sub_items'][$object_key] = $object_value->get_item_add_information();
													}
												}
											}
										}
									}
								}
							}
							else
							{
								$parent_sample_array = SampleItem::list_sample_id_by_item_id_and_gid_and_parent($this->get_item_id(), $pos_id);
								
								if (is_array($parent_sample_array) and count($parent_sample_array) >= 1)
								{
									foreach ($parent_sample_array as $parent_sample_key => $parent_sample_value)
									{
										$item_instance = new Sample($parent_sample_value);
										$return_array[$counter]['fulfilled'][$fulfilled_counter]['item_id'] = $item_instance->get_item_id();
										$return_array[$counter]['fulfilled'][$fulfilled_counter]['id'] = $parent_sample_value;
										$return_array[$counter]['fulfilled'][$fulfilled_counter]['name'] = $item_instance->get_item_object_name();
										$item_instance_array[$fulfilled_counter] = $item_instance;
										$fulfilled_counter++;
									}
								}
								
								if ($value['inherit'] == "all" or $force_inherit == true)
								{									
									if (is_array($item_instance_array) and count($item_instance_array) >= 1 and $fulfilled_counter >= 1)
									{
										foreach($item_instance_array as $object_key => $object_value)
										{
											if (is_object($object_value))
											{	
												if ($object_value instanceof ItemHolderInterface)
												{	
													$return_array[$counter]['sub_items'][$object_key] = $object_value->get_item_add_information();
												}
											}
										}
									}
								}
							}
						}
						
						// ITEMI
						if ($value['xml_element'] == "itemi" and !$value['close'])
						{
							if($in_item == true and is_array($item_instance_array) and count($item_instance_array) >= 1)
							{
								foreach($item_instance_array as $object_key => $object_value)
								{
									if (is_numeric($value['pos_id']))
									{
										$pos_id = $value['pos_id'];
									}
									else
									{
										$pos_id = $sub_item_counter;
									}
									$return_array[$counter]['sub_items'][$object_key][$pos_id] = $object_value->get_item_add_information($pos_id);
								}
							}
						}
						
						if ($value['xml_element'] == "item" and $value['close'] == "1")
						{
							$counter++;
							$type_counter = 0;
							$category_counter = 0;
							$fulfilled_counter = 0;
							$in_item = false;
						}
						
						if ($value['xml_element'] == "type" and !$value['close'] and $in_item == true and $value['id'])
						{
							$return_array[$counter]['type_id'][$type_counter] = $value['id'];
							$type_counter++;
						}	
						
						if ($value['xml_element'] == "category" and !$value['close'] and $in_item == true and $value['id'])
						{
							$return_array[$counter]['category_id'][$category_counter] = $value['id'];
							$category_counter++;
						}				
					}
				}
	
				if (is_array($return_array) and count($return_array) >= 1)
				{
					foreach($return_array as $key => $value)
					{
						if (!$value['name'] and $value['type'])
						{
							if ($return_array[$key]['handling_class'])
							{
								$return_array[$key]['name'] = "Add ".$return_array[$key]['handling_class']::get_generic_name($value['type'], $value['type_id']);
							}
						}
						
						if (is_array($value['sub_items']) and count($value['sub_items']) >= 1)
						{
							foreach($value['sub_items'] as $sub_item_key => $sub_item_value)
							{
								if (!$sub_item_value['name'] and $sub_item_value['type'])
								{
									if ($return_array[$key]['sub_items'][$sub_item_key]['handling_class'])
									{
										$return_array[$key]['sub_items'][$sub_item_key]['name'] = "Add ".$return_array[$key]['sub_items'][$sub_item_key]['handling_class']::get_generic_name($sub_item_value['type'], $sub_item_value['type_id']);
									}
								}
							}
						}
					}
				}
								
				$runtime_data->write_object_data($this, "SAMPLE_".$this->sample_id."_REQUIREMENT_ARRAY", $return_array);	
				
				return $return_array;
	    	}
    	}
    	else
    	{
    		return null;
    	}
    }

    /**
	 * @see SampleInterface::is_sub_item_required()
	 * @param integer $parent_pos_id
	 * @param integer $sub_item_pos_id
	 * @return array
	 */
    public function is_sub_item_required($parent_pos_id, $sub_item_pos_id)
    {
    	global $runtime_data;
    	
    	if ($this->sample_id and $this->sample)
    	{
	    	$sample_template 		= new SampleTemplate($this->sample->get_template_id());
	    	
	    	$requirements_array 	= $sample_template->get_requirements();
	    	
	    	if (is_array($requirements_array) and count($requirements_array) >= 1)
			{
				if ($runtime_data->is_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY") == true)
	    		{
					$item_type_array = $runtime_data->read_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY");
	    		}
	    		else
	    		{
	    			$item_type_array = Item::list_types();
	    			$runtime_data->write_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_TYPE_ARRAY", $item_type_array);	
	    		}
	    		
	    		if ($runtime_data->is_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY") == true)
	    		{
	    			$item_array = $runtime_data->read_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY");
	    		}
	    		else
	    		{
	    			$sample_item = new SampleItem($this->sample_id);
					$item_array = $sample_item->get_sample_items_with_pos_id();
					$runtime_data->write_object_data($this, "SAMPLE_".$this->sample_id."_FULFILLED_ITEM_ARRAY", $item_array);	
	    		}
				
				$counter = 0;
				$sub_item_counter = 0;
				$fulfilled_counter = 0;
				$in_item = false;
				
		    	foreach($requirements_array as $key => $value)
				{
					if ($value['xml_element'] == "item" and !$value['close'])
					{
						$in_item = true;
						
						if ($value['pos_id'])
						{
							$pos_id = $value['pos_id'];
						}
						else
						{
							$pos_id = $counter;
						}
						
						if ($pos_id != $parent_pos_id)
						{
							continue;
						}
						else
						{
							if ($value['type'] == "parentsample")
							{
								$parent_sample_array = SampleItem::list_sample_id_by_item_id_and_gid_and_parent($this->get_item_id(), $parent_pos_id);
										
								if (is_array($parent_sample_array) and count($parent_sample_array) >= 1)
								{
									foreach ($parent_sample_array as $parent_sample_key => $parent_sample_value)
									{
										$item_instance = new Sample($parent_sample_value);
										$item_instance_array[$fulfilled_counter] = $item_instance;
										$fulfilled_counter++;
									}
								}
							}
							elseif (is_array($item_array) and count($item_array) >= 1)
							{	
								$item_instance_array = array();
		
								foreach($item_array as $item_key => $item_value)
								{
									if (is_array($item_type_array) and count($item_type_array) >= 1)
									{
										foreach ($item_type_array as $item_type => $item_handling_class)
										{
											if (class_exists($item_handling_class))
											{
												if ($item_handling_class::is_kind_of($item_type, $item_value['item_id']) == true and $item_value['pos_id'] == $pos_id and $item_value['pos_id'] !== null and $pos_id !== null)
												{
													$item_instance_array[$fulfilled_counter] =  $item_handling_class::get_instance_by_item_id($item_value['item_id']);
													$fulfilled_counter++;
													break;
												}
											}
										}
									}
								}
							}
								
							if (is_array($item_instance_array) and count($item_instance_array) >= 1)
							{
								if ($value['inherit'] == "all" or $force_inherit == true)
								{									
									if (is_array($item_instance_array) and count($item_instance_array) >= 1 and $fulfilled_counter >= 1)
									{
										foreach($item_instance_array as $object_key => $object_value)
										{
											if (is_object($object_value))
											{	
												if ($object_value instanceof ItemHolderInterface)
												{	
													$sub_item_array = $object_value->get_item_add_information();
													
													if (is_array($sub_item_array) and count($sub_item_array) >= 1)
													{
														foreach($sub_item_array as $sub_item_key => $sub_item_value)
														{
															if ($sub_item_value['pos_id'] == $sub_item_pos_id)
															{
																return true;
															}
														}
													}
												}
											}
										}
									}
								}
							}
							else
							{
								return false;
							}
						}
					}
					
					if ($value['xml_element'] == "item" and $value['close'] == "1")
					{
						$counter++;
						$sub_item_counter = 0;
						$in_item = false;
					}
					
					if ($value['xml_element'] == "itemi" and !$value['close'])
					{
						if($in_item == true and is_array($item_instance_array) and count($item_instance_array) >= 1)
						{
							foreach($item_instance_array as $object_key => $object_value)
							{
								if (is_numeric($value['pos_id']))
								{
									$pos_id = $value['pos_id'];
								}
								else
								{
									$pos_id = $sub_item_counter;
								}
								
								if ($pos_id == $sub_item_pos_id)
								{
									return true;
								}
								else
								{
									continue;
								}
							}
							$sub_item_counter++;
						}
					}
				}
				
				return false;
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
     * @see SampleInterface::list_required_sub_items()
     * @param integer $parent_pos_id
     * @return array
     */
    public function list_required_sub_items($parent_pos_id)
    {
    	if ($this->sample_id and $this->sample and is_numeric($parent_pos_id))
    	{
    		$sample_template 		= new SampleTemplate($this->sample->get_template_id());
			$requirements_array 	= $sample_template->get_requirements();
    		
    		$return_array = array();
			
			$counter = 0;
			$sub_item_counter = 0;
			$in_item = false;
			
			if (is_array($requirements_array) and count($requirements_array) >= 1)
			{
				foreach($requirements_array as $key => $value)
				{
					if ($value['xml_element'] == "item" and !$value['close'])
					{
						$in_item = true;
						
						if ($value['pos_id'])
						{
							$pos_id = $value['pos_id'];
						}
						else
						{
							$pos_id = $counter;
						}
						
						
						if ($value['inherit'] == "all" and $pos_id == $parent_pos_id)
						{									
							return array(0 => "all");
						}
					}
					
					if ($value['xml_element'] == "item" and $value['close'] == "1")
					{
						$counter++;
						$in_item = false;
					}

					
					// ITEMI
					if ($value['xml_element'] == "itemi" and !$value['close'])
					{
						if($in_item == true)
						{
							if (is_numeric($value['pos_id']))
							{
								$pos_id = $value['pos_id'];
							}
							else
							{
								$pos_id = $sub_item_counter;
							}
							
							if (!in_array($pos_id, $return_array))
							{
								array_push($return_array, $pos_id);
							}
							$sub_item_counter++;
						}
					}
				}	
			}    		
    		return $return_array;
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_sub_folder()
     * @param integer $folder_id Folder-ID
     * @param integer $gid 
     * @return string Sub-Folder-Path
     */
    public function get_sub_folder($folder_id, $gid)
    {
    	if ($this->sample_id and $this->sample)
    	{
	    	if (is_numeric($folder_id) and is_numeric($gid))
	    	{
				$sample_folder_id = SampleFolder::get_folder_by_sample_id($this->sample_id);
	    		
	    		if ($folder_id == $sample_folder_id)
	    		{
	    			$folder = Folder::get_instance($folder_id);
	    		
	    			$sample_template = new SampleTemplate($this->sample->get_template_id());
	    			$attribute_array = $sample_template->get_gid_attributes($gid);
	    			
	    			if ($attribute_array['folder'])
	    			{
	    				$folder_name = strtolower(trim($attribute_array['folder']));
	    				$folder_name = str_replace(" ","-",$folder_name);
	    				
	    				$folder_path = new Path($folder->get_path());
						$folder_path->add_element($folder_name);

	    				return Folder::get_folder_by_path($folder_path->get_path_string());	    				
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
     * @see SampleInterface::add_location()
     * @param integer location_id
     * @return bool
     */
    public function add_location($location_id)
    {
    	global $user;
    	
    	if ($this->sample_id and $this->sample and is_numeric($location_id))
    	{
    		$sample_has_location = new SampleHasLocation_Access(null);
    		if ($location_id != $this->get_current_location())
    		{
	    		if ($sample_has_location->create($this->sample_id, $location_id, $user->get_user_id()) != null)
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
    	else
    	{
    		return false;
    	}
    }
    
    /**
     * @see SampleInterface::get_current_location()
     * @return integer
     */
    public function get_current_location()
    {
    	if ($this->sample_id and $this->sample)
    	{
	    	if ($this->sample_id and $this->sample)
	    	{
	    		$pk_array = SampleHasLocation_Access::list_entries_by_sample_id($this->sample_id);
	    		if (is_array($pk_array) and count($pk_array) >= 1)
	    		{
	    			foreach ($pk_array as $key => $value)
	    			{
	    				$sample_has_location = new SampleHasLocation_Access($value);
	    				$last_element = $sample_has_location->get_location_id();
	    			}
	    			return $last_element;
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
    	else
    	{
    		return null;
    	}	
    }    
    
    /**
     * @see SampleInterface::get_name()
     * @return string
     */
    public function get_name()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_name();
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_description()
     * @return string;
     */
    public function get_description()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_comment();
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_datetime()
     * @return string
     */
    public function get_datetime()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_datetime();
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_owner_id()
     * @return integer
     */
    public function get_owner_id()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_owner_id();
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_manufacturer_id()
     * @return string
     */
    public function get_manufacturer_id()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_manufacturer_id();
    	}
    	else
    	{
    		return null;
    	}
    }
    
    /**
     * @see SampleInterface::get_template_id()
     * @return integer
     */
    public function get_template_id()
    {
    	if ($this->sample_id and $this->sample)
    	{
    		return $this->sample->get_template_id();
    	}
    	else
    	{
    		return null;
    	}
    }
	
	/**
	 * @see SampleInterface::get_availability()
	 * @return bool
	 */
	public function get_availability()
	{
		if ($this->sample_id and $this->sample)
		{
			return $this->sample->get_available();
		}
		else
		{
			return false;
		}		
	}
	
	/**
	 * @see SampleInterface::get_date_of_expiry()
	 * @return bool
	 */
	public function get_date_of_expiry()
	{
		if ($this->sample_id and $this->sample)
		{
			return $this->sample->get_date_of_expiry();
		}
		else
		{
			return null;
		}		
	}
		
	/**
	 * @see SampleInterface::get_current_location_name()
	 * @return string
	 */
	public function get_current_location_name()
	{
		if ($this->sample_id and $this->sample)
		{
			$location_id = $this->get_current_location();
			$location = new Location($location_id);
			if ($location_name = $location->get_name(false)) 
			{
				return $location_name;
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
	 * @see SampleInterface::get_template_name()
	 * @return string
	 */
	public function get_template_name()
	{
		if ($this->sample_id and $this->sample)
		{
			$sample_template_id = $this->get_template_id();
			$sample_template = new SampleTemplate($sample_template_id);
			return $sample_template->get_name();
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see SampleInterface::get_formatted_id()
	 * @return string
	 */
	public function get_formatted_id()
	{
		if ($this->sample_id)
		{
    		return "S".str_pad($this->sample_id, 8 ,'0', STR_PAD_LEFT);
    	}
    	else
    	{
    		return null;
    	}
	}
	
	/**
	 * @see SampleInterface::get_organisation_unit_id()
	 * @return integer
	 */
	public function get_organisation_unit_id()
	{
    	if ($this->sample_id)
    	{
    		$sample_security = new SampleSecurity($this->sample_id);
    		$sample_security_array = $sample_security->list_organisation_units();
    		if (is_array($sample_security_array) and count($sample_security_array) >= 1)
    		{
    			return $sample_security_array[0];
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
	 * @see SampleInterface::set_name()
	 * @param string $name
	 * @return bool
	 */
	public function set_name($name)
	{
		global $transaction;

		if ($this->sample_id and $this->sample and $name)
		{
    		$transaction_id = $transaction->begin();

	    	$folder_id = SampleFolder::get_folder_by_sample_id($this->sample_id);
	    	$folder = Folder::get_instance($folder_id);

	    	$folder_name = $name." (".$this->get_formatted_id().")";
	    	
			if ($folder->set_name($folder_name) == false)
			{
				if ($transaction_id != null)
				{
					$transaction->rollback($transaction_id);
				}
				return false;
			}
    		
    		if ($this->sample->set_name($name) == false)
    		{
    			if ($transaction_id != null)
				{
					$transaction->rollback($transaction_id);
				}
				return false;
    		}
    		else
    		{
    			if ($transaction_id != null)
				{
					$transaction->commit($transaction_id);
				}
				return true;
    		}
    	}
    	else
    	{
    		return false;
    	}
	}
	
	/**
	 * @see SampleInterface::set_owner_id()
	 * @param integer $owner_id
	 * @return bool
	 */
	public function set_owner_id($owner_id)
	{
		if ($this->sample_id and $this->sample and is_numeric($owner_id))
		{
    		return $this->sample->set_owner_id($owner_id);
    	}
    	else
    	{
    		return false;
    	}
	}
	
	/**
	 * @see SampleInterface::set_manufacturer_id()
	 * @param string $supplier
	 * @return bool
	 */
	public function set_manufacturer_id($manufacturer_id)
	{
		if ($this->sample_id and $this->sample)
		{
    		return $this->sample->set_manufacturer_id($manufacturer_id);
    	}
    	else
    	{
    		return false;
    	}
	}
	
	/**
	 * @see SampleInterface::set_availability()
	 * @param bool $availability
	 * @return bool
	 */
	public function set_availability($availability)
	{
		if ($this->sample_id and $this->sample and isset($availability))
		{
    		return $this->sample->set_available($availability);
    	}
    	else
    	{
    		return false;
    	}
	}
	
	/**
	 * @see ItemHolderInterface::get_item_add_information()
	 * @param integer $id
	 * @return array
	 */
	public final function get_item_add_information($id= null)
	{
		if ($this->sample_id)
		{
			$requirements_array = $this->get_requirements(false);
			unset($requirements_array['fulfilled']);
			if (is_numeric($id))
			{
				return $requirements_array[$id];
			}
			else
			{
				return $requirements_array;
			}
		}
	}
		
	/**
	 * @see ItemListenerInterface::get_item_object_id()
	 * @return integer
	 */
	public final function get_item_object_id()
	{
		if ($this->sample_id)
		{
			return $this->sample_id;
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
		if ($this->sample_id and $this->sample)
		{
			return $this->sample->get_name();
		}
		else
		{
			return null;
		}
	}
    
    /**
     * @see ItemListenerInterface::get_item_parents()
	 * @return string
	 */
	public final function get_item_parents()
	{
		if ($this->item_id)
		{
			$parent_sample_array = SampleItem::list_entries_by_item_id($this->item_id, true);
			
			if (is_array($parent_sample_array) and count($parent_sample_array) >= 1)
			{
				$return_array = array();
				
				foreach($parent_sample_array as $key => $value)
				{
					$sample_is_item = new SampleIsItem_Access($value['id']);
    				array_push($return_array, $sample_is_item->get_item_id());
				}
				
				return $return_array;
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
	 * @see ItemHolderInterface::get_item_holder_value()
	 * @param string $address
	 * @param integer $position_id
	 * @return mixed
	 */
	public final function get_item_holder_value($address, $position_id = null)
	{
		if ($this->sample_id and $this->sample)
		{
			switch($address):
			
				case "folder_id":
					$folder_id = SampleFolder::get_folder_by_sample_id($this->sample_id);
										
					$sub_folder_id = $this->get_sub_folder($folder_id, $position_id);				
	
					if (is_numeric($sub_folder_id))
					{
						$folder_id = $sub_folder_id;
					}
					
					return $folder_id;
				break;
				
				case "organisation_unin_id":
					return $this->get_organisation_unit_id();
				break;
			
				default:
					return null;
				break;
			
			endswitch;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemHolderListenerInterface::get_item_holder_items()
	 * @param integer $position_id
	 * @return array
	 */
	public final function get_item_holder_items($position_id)
	{
		if (is_numeric($position_id) and $this->sample_id and $this->sample)
		{
			return SampleItem::list_items_by_sample_id_and_gid($this->sample_id, $position_id);
		}
		else
		{
			return SampleItem::list_items_by_sample_id_and_gid($this->sample_id, null);
		}
	}
	
	
	/**
	 * @see SampleInterface::exist_sample()
	 * @param integer $sample_id
	 * @return bool
	 */
   	public static function exist_sample($sample_id)
   	{
		return Sample_Access::exist_sample_by_sample_id($sample_id);
   	}

   	/**
   	 * @see SampleInterface::list_samples_by_item_sql_list()
	 * @param string $sql
	 * @return array
	 */
	public static function list_samples_by_item_sql_list($sql)
	{
		return SampleIsItem_Access::list_samples_by_item_sql_list($sql);
	}
   	
   	/**
   	 * @see SampleInterface::list_user_related_samples()
   	 * @param integer $user_id
   	 * @return array
   	 */
    public static function list_user_related_samples($user_id)
    {
    	return SampleHasUser_Access::list_samples_by_user_id($user_id);
    }
    
    /**
     * @see SampleInterface::list_organisation_unit_related_samples()
     * @param integer $organisation_unit_id
     * @return array
     */
    public static function list_organisation_unit_related_samples($organisation_unit_id)
    {
    	if (is_numeric($organisation_unit_id))
    	{
    		$pk_array = SampleHasOrganisationUnit_Access::list_entries_by_organisation_unit_id($organisation_unit_id);
    		
    		if (is_array($pk_array) and count($pk_array) >= 1)
    		{
    			$return_array = array();
    			
    			foreach ($pk_array as $key => $value)
    			{
    				$sample_has_organisation_unit_access = new SampleHasOrganisationUnit_Access($value);
    				array_push($return_array, $sample_has_organisation_unit_access->get_sample_id());
    			}
    			return $return_array;
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
     * @see SampleInterface::list_entries_by_template_id()
   	 * @param integer $template_id
   	 * @return array
   	 */
    public static function list_entries_by_template_id($template_id)
    {
    	return Sample_Access::list_entries_by_template_id($template_id);;
    }
    
	/**
	 * @see ItemListenerInterface::clone_item()
	 * @param integer $item_id
	 * @return integer
	 */
	public static function clone_item($item_id)
	{
		return $item_id;
	}
	
	/**
	 * @see ItemListenerInterface::get_entry_by_item_id()
	 * @param integer $item_id
	 * @return integer
	 */
	public static function get_entry_by_item_id($item_id)
	{
		return SampleIsItem_Access::get_entry_by_item_id($item_id);
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
    		if (($sample_id = SampleIsItem_Access::get_entry_by_item_id($item_id)) != null)
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
     * @see ItemListenerInterface::is_type_or_category()
	 * @param $category_id
	 * @param integer $type_id
	 * @param integer $item_id
	 * @return bool
	 */
    public static function is_type_or_category($category_id, $type_id, $item_id)
    {
    	if (is_numeric($type_id))
    	{
    		$sample_id = SampleIsItem_Access::get_entry_by_item_id($item_id);
    		$sample = new Sample($sample_id);
    		
    		if ($sample->get_template_id() == $type_id)
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
    		$sample_id = SampleIsItem_Access::get_entry_by_item_id($item_id);
    		$sample = new Sample($sample_id);
    		$sample_template = new SampleTemplate($sample->get_template_id());
    		
    		if ($sample_template->get_cat_id() == $category_id)
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
    		$sample_id = SampleIsItem_Access::get_entry_by_item_id($item_id);
    		return new Sample($sample_id);
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
    	if (is_array($type_array) and count($type_array) == 1)
    	{
			$sample_template = new SampleTemplate($type_array[0]);

			if ($sample_template->get_name() != null)
			{
				return $sample_template->get_name();
			}
			else
			{
				if ($type == "parentsample")
	    		{
	    			return "Parent Sample";
	    		}
	    		else
	    		{
	    			return "Sample";
	    		}
			}
    	}
    	else
    	{
    		if ($type == "parentsample")
    		{
    			return "Parent Sample";
    		}
    		else
    		{
    			return "Sample";
    		}
    	}
    }

    /**
     * @see ItemListenerInterface::get_generic_symbol()
	 * @param string $type
	 * @param integer $id
	 * @return string
	 */
    public static function get_generic_symbol($type, $id)
    {
   		if ($type == "sample")
    	{
    		return "<img src='images/icons/sample.png' alt='' style='border: 0;' />";
    	}
    }
    
    /**
     * @see ItemListenerInterface::get_generic_link()
	 * @param string $type
	 * @param integer $id
	 * @return string
	 */
	public static function get_generic_link($type, $id)
	{
		if ($type == "sample")
		{
			$paramquery['username'] = $_GET['username'];
			$paramquery['session_id'] = $_GET['session_id'];
			$paramquery['nav'] = "sample";
			$paramquery['run'] = "detail";
			$paramquery['sample_id'] = $id;
			return http_build_query($paramquery, '', '&#38;');
		}
	}
    
	/**
	 * @see ItemListenerInterface::get_sql_select_array()
	 * @param string $type
	 * @return array
	 */
	public static function get_sql_select_array($type)
    {
   		if ($type == "sample")
		{
			$select_array['name'] = "".constant("SAMPLE_TABLE").".name";
			$select_array['type_id'] = "".constant("SAMPLE_TABLE").".id AS sample_id";
			$select_array['datetime'] = "".constant("SAMPLE_TABLE").".datetime";
			return $select_array;
		}
		else
		{
			return null;
		}
    }
    
    /**
     * @see ItemListenerInterface::get_sql_join()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_join($type)
	{
		if ($type == "sample")
		{
			return 	"LEFT JOIN ".constant("SAMPLE_IS_ITEM_TABLE")." 	ON ".constant("ITEM_TABLE").".id 					= ".constant("SAMPLE_IS_ITEM_TABLE").".item_id " .
					"LEFT JOIN ".constant("SAMPLE_TABLE")." 			ON ".constant("SAMPLE_IS_ITEM_TABLE").".sample_id 	= ".constant("SAMPLE_TABLE").".id ";
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_where()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_where($type)
	{
		if ($type == "sample")
		{
			return "(LOWER(TRIM(".constant("SAMPLE_TABLE").".name)) LIKE '{STRING}')";
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_select_array()
	 * @param string $type
	 * @return array
	 */
	public static function get_sql_fulltext_select_array($type)
	{
		if ($type == "sample")
		{
			$select_array['name'] = "".constant("SAMPLE_TABLE").".name";
			$select_array['type_id'] = "".constant("SAMPLE_TABLE").".id AS sample_id";
			$select_array['datetime'] = "".constant("SAMPLE_TABLE").".datetime";
			$select_array['rank'] = "ts_rank_cd(".constant("SAMPLE_TABLE").".comment_text_search_vector, to_tsquery('{LANGUAGE}', '{STRING}'), 32 /* rank/(rank+1) */)";
			return $select_array;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_join()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_fulltext_join($type)
	{
		if ($type == "sample")
		{
			return 	"LEFT JOIN ".constant("SAMPLE_IS_ITEM_TABLE")." 	ON ".constant("ITEM_TABLE").".id 					= ".constant("SAMPLE_IS_ITEM_TABLE").".item_id " .
					"LEFT JOIN ".constant("SAMPLE_TABLE")." 			ON ".constant("SAMPLE_IS_ITEM_TABLE").".sample_id 	= ".constant("SAMPLE_TABLE").".id ";
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_sql_fulltext_where()
	 * @param string $type
	 * @return string
	 */
	public static function get_sql_fulltext_where($type)
	{
		if ($type == "sample")
		{
			return "".constant("SAMPLE_TABLE").".comment_text_search_vector @@ to_tsquery('{LANGUAGE}', '{STRING}')";
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * @see ItemListenerInterface::get_item_add_dialog()
	 * @return array
	 */
	public static function get_item_add_dialog($item_type)
	{
		return array(array("page"), "page");
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
		return null;
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
    		$sample_array = self::list_user_related_samples($event_object->get_user_id());
			
			if (is_array($sample_array))
			{
				if (count($sample_array) >= 1)
				{
					return false;
				}
			}
    	}
    	
    	if ($event_object instanceof OrganisationUnitDeletePrecheckEvent)
    	{
    		$sample_array = self::list_organisation_unit_related_samples($event_object->get_organisation_unit_id());
			
			if (is_array($sample_array))
			{
				if (count($sample_array) >= 1)
				{
					return false;
				}
			}
    	}
    	
   		if ($event_object instanceof LocationDeleteEvent)
    	{
    		if (SampleHasLocation_Access::delete_by_location_id($event_object->get_location_id()) == false)
			{
				return false;
			}
    	}
    	
   		if ($event_object instanceof ItemUnlinkEvent)
    	{
    		// Do Nothing, Sample will not be deleted
    	}
    	
    	return true;
    }
    
	/**
     * @see ItemHolderInterface::get_item_list_sql()
	 * @param integer $holder_id
	 * @return string
	 */
	public static function get_item_list_sql($holder_id)
	{
		return " SELECT item_id FROM ".constant("SAMPLE_HAS_ITEM_TABLE")." WHERE sample_id = ".$holder_id."";
	}

	/**
	 * @see ItemHolderInterface::list_item_holders_by_item_id()
	 * @param $item_id $holder_id
	 * @return array
	 */
	public static function list_item_holders_by_item_id($item_id)
	{
		return SampleItem::list_entries_by_item_id($item_id, false);
	}
	
	/**
	 * @see ItemHolderListenerInterface::get_item_add_io_handling_class()
	 * @return array
	 */
	public static function get_item_add_io_handling_class()
	{
		return array("sample/sample.request.php", "SampleRequest");
	}
}
?>