OFSYS_USERNAME=Ofsys SFTP login
OFSYS_PASSWORD=Strong password with escaped \# and $$ symbols

-include .env

GET_BATCHES = {\"AuthKey\": {\"idKey\": \"${OFSYS_IDKEY}\", \"Key\": \"${OFSYS_KEY}\"},  \
			   \"idProject\": ${OFSYS_IDPROJECT},                              \
			   \"batchFilter\": {\"BatchFilterMode\": \"idBatch\",                 \
								  \"idBatch_Min\": 0,                             \
								  \"idBatch_Max\": 1000000000}}

all :
	fetch
	unpack

unpack :
	# unpack found files:
	find data/*.rar -type f | while read filename; do \
		folder=$${filename%.rar}; \
		unrar x -y $${filename} $${folder}/; \
	done

fetch :
	# fetch data from Ofsys
	# echo $$OFSYS_PASSWORD
	echo 'mget EXPORTS/* data/' | sftp $$OFSYS_USERNAME@sftp.ofsys.com


get_batches:
	# fetch all batches because website cannot do this.
	curl -d "${GET_BATCHES}" 'https://ofsys.com/webservices/ofc4/sendings.ashx?method=GetBatches' \
	     -o data/all_batches.json