#! /bin/bash

error_trap () {
  local command="$BASH_COMMAND" code=$? body=
  printf "\033[31mCommand [$command] exited with code [$code]\033[0m\n"
  ERROR=1
}

trap error_trap ERR

set -E

# For amd overclocking on linux:
# https://www.kernel.org/doc/html/latest/gpu/amdgpu/thermal.html

# GPU to overclock
CARD="/sys/devices/pci0000:64/0000:64:00.0/0000:65:00.0/0000:66:00.0/0000:67:00.0"
ERROR=0
OUTPUT=""

help () {
  
  echo ""
  echo "overckock OPTION"
  echo ""
  echo "Options:"
  echo "-a || --apply      Apply overclock settings"
  echo "-r || --revert          Revert to default settings"
  echo "-h || --help            Show this help message"
}

apply () { 
  echo "Applying GPU settings."

  # Fan curve
  # INDEX FAN% TEMP
  echo '0 25 20' > "$CARD"/gpu_od/fan_ctrl/fan_curve
  echo '1 50 25' > "$CARD"/gpu_od/fan_ctrl/fan_curve
  echo '2 60 50' > "$CARD"/gpu_od/fan_ctrl/fan_curve
  echo '3 70 80' > "$CARD"/gpu_od/fan_ctrl/fan_curve
  echo '4 80 100' > "$CARD"/gpu_od/fan_ctrl/fan_curve
  echo 'c' > "$CARD"/gpu_od/fan_ctrl/fan_curve

  # Set Profile
  echo 'manual' > "$CARD"/power_dpm_force_performance_level
  echo '1' > "$CARD"/pp_power_profile_mode # 1 referring to 3D Fullscreen
  echo '3' > "$CARD"/pp_dpm_mclk # Force highest memory clock

  # Power limit
  cat "$CARD"/hwmon/hwmon2/power1_cap_max > "$CARD"/hwmon/hwmon2/power1_cap

  # Overclock
  echo 's 1 3000' > "$CARD"/pp_od_clk_voltage # Core freq
  echo 'm 1 750' > "$CARD"/pp_od_clk_voltage # Memory freq
  echo 'vo -50' > "$CARD"/pp_od_clk_voltage # Testing for stability -65

  echo 'c' > "$CARD"/pp_od_clk_voltage # Apply OC

  echo "Applying CPU settings"

  pstate=$(cat /sys/devices/system/cpu/intel_pstate/status)

  if [ $pstate == "active" ]; then
    echo "Cpu is using 'intel_pstate=active"

    for dir in /sys/devices/system/cpu/cpu*/; do
      [[ ! "$dir" =~ ^/sys/devices/system/cpu/cpu[0-9]+/$ ]] && continue
      echo "performance" > "${dir}cpufreq/scaling_governor"
      echo 3 > ${dir}power/energy_perf_bias # (EPB) Scale from 0-15 where 0 if preformence and 15 if powersave, 6 is default
      #echo "balance_performance" > "${dir}cpufreq/energy_performance_preference" # (EPP)
    done
  fi

  # For intel_pstate=passive
  #echo schedutil | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  # Energy Preformence bias (EPB)
  #echo 5 | tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias # Scale from 0-15 where 0 if preformence and 15 if powersave, 6 is default
}

revert () {
  echo "Reverting GPU settings."
 
  # Fan curve
  echo 'r' > "$CARD"/gpu_od/fan_ctrl/fan_curve

  echo 'auto' > "$CARD"/power_dpm_force_performance_level # Revert preformence level
  cat "$CARD"/hwmon/hwmon2/power1_cap_default > "$CARD"/hwmon/hwmon2/power1_cap # Revert power cap
  echo 'r' > "$CARD"/pp_od_clk_voltage # Revert overclock

  echo "Reverting CPU settings."

  # Governer
  #echo ondemand | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  # Preformence bias
  #echo 6 | tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias # Scale from 0-15 where 0 if preformence and 15 if powersave, 6 is default

}

if [[ $# -lt 1 ]]; then
  echo "Too few args!"
  help
  exit 1
elif [[ $# -gt 1 ]]; then
  echo "Too many args!"
  help
  exit 1
fi

case $1 in
  -a|--apply)
    apply
    ;;
  -r|--revert)
    revert
    ;;
  -h|--help)
    help
    ;;
  *)
    echo "Unknown option $1"
    help
    exit 1
    ;;
esac

echo ""
echo "Done!"

exit $ERROR
