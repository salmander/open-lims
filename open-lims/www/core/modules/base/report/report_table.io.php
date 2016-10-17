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
 * List IO Class
 * Handles lists
 * Use this instead of Table_IO
 * @package base
 */
class ReportTable_IO
{
	private $pdf;
	
	private $header_array = array();
	private $content_array = array();
	private $width_array = array();
	private $max_width = 190;
	
	private $font_size;
	private $height;
	
	/**
	 * @param object $pdf
	 * @param integer $height
	 */
	function __construct($pdf, $height='', $font_size = null)
	{
		if (is_object($pdf))
		{
			$this->pdf = $pdf;
			if ($height)
			{
				$this->height = $height;
			}
			if ($font_size)
			{
				$this->font_size = $font_size;
			}
		}
		else
		{
			$this->pdf = null;
		}
	}
	
	function __destruct()
	{
		unset($this->pdf);
	}
	
	/**
	 * @param array $header_array
	 * @return bool
	 */
	public function add_header($header_array)
	{
		if (is_array($header_array))
		{
			$this->header_array = $header_array;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * @param array $content_array
	 * @return bool
	 */
	public function add_line($content_array)
	{
		if (is_array($content_array))
		{
			array_push($this->content_array, $content_array);
			return true;
		}	
		else
		{
			return false;
		}
	}
	
	private function get_header()
	{
		if (is_array($this->header_array) and count($this->header_array) >= 1)
		{
			if ($this->font_size)
			{
				$this->pdf->SetFont('dejavusans', 'B', $this->font_size, '', true);
			}
			else
			{
				$this->pdf->SetFont('dejavusans', 'B', 14, '', true);
			}
			
			
			foreach($this->header_array as $key => $value)
			{
				if ($value['width'])
				{
					$this->width_array[$value['name']] = $value['width'];
					$this->pdf->MultiCell($value['width'], '', $value['title'], 1, 'L', 1, 0, '', '', true, 0, true, true, 0, "T");
				}
			}
			
			$this->pdf->ln();
		}
	}
	
	/**
	 * @return object
	 */
	public function get_pdf()
	{
		if (is_array($this->content_array) and count($this->content_array) >= 1)
		{
			$this->get_header();
			
			if ($this->font_size)
			{
				$this->pdf->SetFont('dejavusans', '', $this->font_size, '', true);
			}
			else
			{
				$this->pdf->SetFont('dejavusans', '', 14, '', true);
			}
			
			foreach($this->content_array as $key => $value)
			{
				$height = $this->height;
				
				foreach($value as $sub_key => $sub_value)
				{
					if (($width = $this->width_array[$sub_value['name']]) != null)
					{
						$string_height = $this->pdf->getStringHeight($width, $sub_value['content'], true, true, '', 1);
						
						if ($string_height > $height)
						{
							$height = $string_height;
						}
					}
				}
				
				foreach($value as $sub_key => $sub_value)
				{
					if (($width = $this->width_array[$sub_value['name']]) != null)
					{
						$this->pdf->MultiCell($width, $height, $sub_value['content'], 1, 'L', 1, 0, '', '', true, 0, true, true, 0, "T");
					}
				}
				
				$this->pdf->ln();
			}
		}
		
		return $this->pdf;
	}
}