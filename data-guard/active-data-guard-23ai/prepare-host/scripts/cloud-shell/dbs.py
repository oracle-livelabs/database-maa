# run this script from a cloud shell started in the correct region.
# export the compartment OCID like this:
#   export COMPARTMENT_OCID=ocid1.compartment.oc1..aaaaaaaao2tnhisdy47fk2fagk2ijae5edzbfqlajh3ztaynfkjsjbl7tjaa
# then run the script.


import oci
import os
comp_id = os.environ["COMPARTMENT_OCID"]
config = oci.config.from_file(profile_name=os.environ["OCI_CONFIG_PROFILE"])

database_client = oci.database.DatabaseClient(config)
identity_client = oci.identity.IdentityClient(config)
core_client = oci.core.VirtualNetworkClient(config)

# this will contain our data
dbs = []

# find the db_systems in the compartment (it's LiveLabs, we should have 2)
dbsystems = database_client.list_db_systems(compartment_id=comp_id)

assert(len(dbsystems.data) == 2)

for dbs_i in dbsystems.data:
  
  db = dict()
  db["dbsystems"] = dbs_i
  
  # find the nodes in the dbsystem (it's LiveLabs, we should have 1) 
  nodes = database_client.list_db_nodes(compartment_id = comp_id, db_system_id = dbs_i.id)
  assert(len(nodes.data) == 1)
  db["nodes"] = nodes.data[0]
  
  # get the vnic that has the public ip
  vnics = core_client.get_vnic(vnic_id = nodes.data[0].vnic_id)	
  db["vnics"] = vnics.data
  
  # find the db_homes in the db_system (it's LiveLabs, we should have 1)
  db_homes = database_client.list_db_homes(compartment_id = comp_id, db_system_id = dbs_i.id)
  assert(len(db_homes.data) == 1)
  db["db_homes"] = db_homes.data[0]
  
  # find the dbs in the db_home (it's LiveLabs, we should have 1) 
  databases = database_client.list_databases(compartment_id = comp_id, system_id = dbs_i.id, db_home_id = db_homes.data[0].id)
  db["databases"] = databases.data[0]
  
  dbs.append(db)

# sort the db systems by display name in case the creation messed the order up. 
dbs.sort(key=lambda x: x["dbsystems"].display_name)

for db in dbs:
  print("##############################")
  print("# %-26s " % db["dbsystems"].display_name)
  print("Display Name           : %s" % db["dbsystems"].display_name)
  print("Hostname               : %s" % db["nodes"].hostname)
  print("Public IP Address      : %s" % db["vnics"].public_ip) 
  print("Listener Port          : %s" % db["dbsystems"].listener_port)
  print("DB_UNIQUE_NAME         : %s" % db["databases"].db_unique_name)
  print("DGConnectIdentifier    : {host}.{domain}:{port}/{dbun}.{domain}".format(
    host=db["nodes"].hostname,
	domain=db["dbsystems"].domain,
	port=db["dbsystems"].listener_port,
	dbun=db["databases"].db_unique_name
	))
  print("StaticConnectIdentifier: {host}.{domain}:{port}/{dbun}_DGMGRL.{domain}".format(
    host=db["nodes"].hostname,
	domain=db["dbsystems"].domain,
	port=db["dbsystems"].listener_port,
	dbun=db["databases"].db_unique_name
	))
  
  print()
  
