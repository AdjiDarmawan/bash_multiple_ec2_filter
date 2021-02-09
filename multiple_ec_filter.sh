#!/bin/bash
echo "======================================"
echo "= PILIH METODE AWS QUERY DIBAWAH INI ="
echo "======================================"
PS3="Pilihan Metode AWS Query Anda Adalah : "
select menu_option in BaseOnSubnetID BaseOnImageID BaseOnTags CountEc2 Exit; do
  printf "%s\n"
  case $menu_option in
    BaseOnSubnetID)
      read -p "Masukkan AWS Profile Anda : " profile_aws
      read -p "Masukkan juga SUBNET-ID nya : " subnet_id

      count_ec2="$(aws ec2 describe-instances --profile $profile_aws --query 'Reservations[].Instances[].[InstanceId]' --filters Name=subnet-id,Values=$subnet_id --output text | wc -l)"

      aws ec2 describe-instances --profile $profile_aws \
      --query "Reservations[].Instances[].{InstanceID:InstanceId,Name:Tags[?Key=='Name'].Value[] | [0],IPAddress:PrivateIpAddress,Status:State.Name,Zone:Placement.AvailabilityZone}" \
      --filters Name=network-interface.subnet-id,Values=$subnet_id \
      --output text | sort -k1

      printf "%s\n"
      echo "Jumlah EC2 di Environment "["$profile_aws"]" dengan SubnetID "["$subnet_id"]" adalah :" $count_ec2
      printf "%s\n"
    ;;

    BaseOnImageID)
      read -p "Masukkan AWS Profile Anda : " profile_aws
      read -p "Masukkan juga IMAGE-ID nya : " images_id

      count_ec2="$(aws ec2 describe-instances --profile $profile_aws --query 'Reservations[].Instances[].[InstanceId]' --filters Name=image-id,Values=$images_id --output text | wc -l)"

      aws ec2 describe-instances --profile $profile_aws \
      --query "Reservations[].Instances[].{InstanceID:InstanceId,Name:Tags[?Key=='Name'].Value[] | [0],IPAddress:PrivateIpAddress,Status:State.Name,Zone:Placement.AvailabilityZone}" \
      --filters Name=image-id,Values=$images_id \
      --output text | sort -k1

      printf "%s\n"
      echo "Jumlah EC2 di Environment "["$profile_aws"]" dengan SubnetID "["$images_id"]" adalah :" $count_ec2
      printf "%s\n"
    ;;

    BaseOnTags)
      read -p "Masukkan Profile AWS dulu ya ... : " profile_aws
      read -p "Sekarang Masukkan TagsNamenya : " tags_name
      read -p "Masukkan Juga Tags Value nya : " tags_values

      count_ec2="$(aws ec2 describe-instances --profile $profile_aws --query 'Reservations[].Instances[].[InstanceId]' --filters Name=tag:$tags_name,Values=$tags_values --output text | wc -l)"

      aws ec2 describe-instances --profile $profile_aws \
      --query "Reservations[].Instances[].{InstanceID:InstanceId,Name:Tags[?Key=='Name'].Value[] | [0],IPAddress:PrivateIpAddress,Status:State.Name,Zone:Placement.AvailabilityZone}" \
      --filters Name=tag:$tags_name,Values=$tags_values \
      --output text | sort -k1

      printf "%s\n"
      echo "Jumlah EC2 di Environment "["$profile_aws"]" dengan TagName "["$tags_name"]" dan TagValues nya "["$tags_values"]" adalah :" $count_ec2 "Instance/EC2"
      printf "%s\n"
    ;;

    CountEc2)
      read -p "Masukkan AWS Profile Anda : " profile_aws
      count_ec2="$(aws ec2 describe-instances --profile=$profile_aws --query 'Reservations[].Instances[].[InstanceId]' --output text | wc -l)"

      echo "AWS Profile Anda Adalah $profile_aws";
      echo "Jumlah Host di Environment $profile_aws adalah :" $count_ec2
      echo "CATATAN :" "'Jumlah Host Tersebut di atas Untuk Informasi Jumlah Host di Sajikan Secara Keseluruhan (Termasuk Host yang Berstatus Stopped)'"
    ;;

    Exit)
    break
    ;;
    *)
      echo "Lau Pilih Metode Filter yang mana sih, NGGA ADA NICH ...!!!! $REPLY"
    ;;
  esac
done
