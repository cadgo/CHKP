#google teste api                                                                                                                                                                                                                                                                            
API_TO_TEST="kms iam app bigquery admin functions sql bigtable pub sub memorystorage usage filestore api logging dns asset contacts approval"
LOG=gcpresult.log                                     
                                                   
touch $LOG                                            
                                                       
for i in $API_TO_TEST                                 
do                               
   gcloud services list --enabled | grep -i $i >> $LOG                                                                                                      
done   
