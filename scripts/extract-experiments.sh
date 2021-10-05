for experiment in $(yq r workflow.yaml -j |jq -r '.spec.templates[1].inputs.artifacts[] |@base64'); do
    _jq() {
     echo ${experiment} | base64 --decode | jq -r ${1}
    }

   name=$(_jq '.name')
   raw=$(_jq '.raw.data')
   echo "$raw" > ${name}-chaos-experiment.tpl
done

for experiment in $(yq r workflow.yaml -j |jq -r '.spec.templates[1].inputs.artifacts[] |@base64'); do
    _jq() {
     echo ${experiment} | base64 --decode | jq -r ${1}
    }

   name=$(_jq '.name')
   raw=$(_jq '.raw.data')
   echo "$raw" > ${name}-chaos-experiment.tpl
done
