#!/bin/bash

# Define the image, and instance parameters
IMAGE="daily:24.10"
CPUS="4"
MEMORY="8G"
DISK="30G"

echo "Starting a multipass instance with $CPUS CPUs, $MEMORY memory, and $DISK disk space, using the $IMAGE image."
echo

start_time=$(date +%s)

# Check if the first argument is "desktop" and adjust the multipass launch command accordingly
if [[ "$1" == "desktop" ]]; then
  echo "Using cloud-init.yml for instance setup."
  VM_NAME=$(multipass launch "$IMAGE" --cpus "$CPUS" --memory $MEMORY --disk $DISK --cloud-init cloud-init.yml --timeout 600 | grep Starting | awk '{print $2}')
else
  VM_NAME=$(multipass launch "$IMAGE" --cpus "$CPUS" --memory $MEMORY --disk $DISK --timeout 600 | grep Starting | awk '{print $2}')
fi

echo "Launched VM: $VM_NAME with image: $IMAGE"

# Poll to check if the instance is running and obtain the IP address
while true; do
  STATUS=$(multipass info "$VM_NAME" | grep State | awk '{print $2}')
  IP_ADDRESS=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')

  if [[ "$STATUS" == "Running" && -n "$IP_ADDRESS" ]]; then
    echo "Instance $VM_NAME is running and accessible at $IP_ADDRESS"
    break
  else
    echo "Waiting for instance $VM_NAME to be available..."
    sleep 5
  fi
done

end_time=$(date +%s)
duration=$((end_time - start_time))

echo "Provisioning took $duration seconds."

echo
echo "Copying multipass ssh key to home folder and changing ownership/permissions."
echo

sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa "$HOME/id_rsa" # for Ubuntu Linux
#sudo cp /var/root/Library/Application\ Support/multipassd/ssh-keys/id_rsa "$HOME/id_rsa" # for macOS
sudo chown "$USER":"$(id -gn)" "$HOME/id_rsa"
chmod 400 "$HOME/id_rsa"

cd ..

#ansible-playbook -i "$IP_ADDRESS," main.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu" --extra-vars "ansible_python_interpreter=/usr/bin/python3"
ansible-playbook -i "$IP_ADDRESS," test.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu" --extra-vars "ansible_python_interpreter=/usr/bin/python3"

echo "Delete the instance with the following commands, when testing is complete:"
echo
echo "multipass delete $VM_NAME"
echo "multipass purge"
echo
echo "Clean up the ssh key from home folder, with the following command:"
echo
echo "sudo rm \"$HOME/id_rsa\""

exit 0
