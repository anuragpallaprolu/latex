<?php
if(!defined('sugarEntry') || !sugarEntry) die('Not A Valid Entry Point');

class PushCustomerDataClass{

                         function PushCustomerDataFun(&$bean, $event, $arguments){
						 							
													 	global $db;
													    $id                                 = $bean->id;
														$name                               = $bean->name;
														$salutation                         = $bean->salutation;
														$first_name                         = $bean->first_name;
														$last_name                          = $bean->last_name;
														$primary_address_street             = $bean->primary_address_street;
														$primary_address_city               = $bean->primary_address_city;
														$primary_address_state              = $bean->primary_address_state;
														$primary_address_postalcode         = $bean->primary_address_postalcode;
														$primary_address_country            = $bean->primary_address_country;   
														$pan_it_no_c                        = $bean->pan_it_no_c;
														$sale_tax_no_c                      = $bean->sale_tax_no_c;
														$cst_no_c                           = $bean->cst_no_c;
														$opening_balance_c                  = $bean->opening_balance_c;
														$opening_bal_type_c                 = $bean->opening_bal_type_c;
														
														$full_name = $salutation." ". $first_name." ".$last_name;
														$address= $primary_address_street." ".$primary_address_city." ".$primary_address_country;
														
														// Here Query for getting Group
														$query="SELECT gu02_group_under.name,gu02_group_under.g_under ";
														$query.=" FROM gu02_group_under, gu02_group_der_contacts_c, contacts ";
														$query.=" WHERE gu02_group_der_contacts_c.gu02_groupe4adp_under_ida = gu02_group_under.id ";
														$query.=" AND gu02_group_under.deleted =0 ";
														$query.=" AND gu02_group_der_contacts_c.gu02_groupc30eontacts_idb = contacts.id ";
														$query.=" AND contacts.id = '".$id."' ";
														$results = $bean->db->query($query, true); 
														$row = $bean->db->fetchByAssoc($results);
														$group_name=$row['name'];
														$tally_default_under=$row['g_under'];
														settype($group_name,string);
														
														if($opening_bal_type_c=='Credit'){
														   $opening_bal='-';
														   $opening_balance=$opening_bal.opening_balance_c;
														}
														else{
														   $opening_bal='';
														   $opening_balance=$opening_bal.opening_balance_c;
														}


														$xml ="<?xml version='1.0' encoding='utf-8'?>
																<ENVELOPE>
																<HEADER>
																<TALLYREQUEST>Import Data</TALLYREQUEST>
																</HEADER>
																<BODY>
																<IMPORTDATA>
																<REQUESTDESC>
																<REPORTNAME>All Masters</REPORTNAME>
																</REQUESTDESC>
																<REQUESTDATA>
																<TALLYMESSAGE xmlns:UDF='TallyUDF'>
																<GROUP NAME='$group_name' Action = 'Create'>
																<NAME.LIST>
																<NAME>$group_name</NAME>
																</NAME.LIST>
																<PARENT>$tally_default_under</PARENT>
																</GROUP>
																<LEDGER NAME='$name' Action = 'Create'>
																<NAME.LIST>
																<NAME>$name</NAME>
																</NAME.LIST>
																<ADDRESS.LIST>
																<ADDRESS></ADDRESS>
																</ADDRESS.LIST>
																<PARENT>$group_name</PARENT>
																<OPENINGBALANCE>$opening_balance</OPENINGBALANCE>
																</LEDGER>
																</TALLYMESSAGE>
																</REQUESTDATA>
																</IMPORTDATA>
																</BODY>
																</ENVELOPE>";
														$url ='http://192.168.1.13'; // here put you IP
														$port = 9002;                // here put your tally port number
														$response=$this->xml_post($xml, $url, $port);			
													
						 
						 }
							function xml_post($post_xml, $url, $port)
											{
											
												$user_agent = $_SERVER['HTTP_USER_AGENT'];
												
												$ch = curl_init();    // initialize curl handle
												curl_setopt($ch, CURLOPT_URL, $url); // set url to post to
												curl_setopt($ch, CURLOPT_FAILONERROR, 1);              // Fail on errors
												curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);	// allow redirects
												curl_setopt($ch, CURLOPT_RETURNTRANSFER,1); // return into a variable
												curl_setopt($ch, CURLOPT_PORT, $port);			//Set the port number
												curl_setopt($ch, CURLOPT_TIMEOUT, 15); // times out after 15s
												curl_setopt($ch, CURLOPT_POSTFIELDS, $post_xml); // add POST fields
												curl_setopt($ch, CURLOPT_USERAGENT, $user_agent);
												
												if($port==443)
												{
												curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,  2);
												curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
												}
												
												$data = curl_exec($ch);
												
												curl_close($ch);
												
												return $data;
	}	




}
?>