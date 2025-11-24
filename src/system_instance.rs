use once_cell::sync::Lazy;
use std::sync::Mutex;
use sysinfo::{Components, System};

static SYSTEM: Lazy<Mutex<System>> = Lazy::new(|| Mutex::new(System::new_all()));

static COMPONENTS: Lazy<Mutex<Components>> =
    Lazy::new(|| Mutex::new(Components::new_with_refreshed_list()));

// Main callable functions

// Get average cpu usage from all the cores
pub fn get_global_cpu_usage() -> f32 {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_cpu_all();

    if sys.cpus().is_empty() {
        return 0.0;
    }

    let total: f32 = sys.cpus().iter().map(|cpu| cpu.cpu_usage()).sum();
    total / sys.cpus().len() as f32
}

// get cpu usage for each core
pub fn get_cpu_core_usage(core_index: usize) -> Option<f32> {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_cpu_all();

    sys.cpus().get(core_index).map(|cpu| cpu.cpu_usage())
}

// get the corecount for current system
pub fn get_cpu_core_count() -> usize {
    let sys = SYSTEM.lock().unwrap();
    sys.cpus().len()
}

// get the core temperature for each core
pub fn get_cpu_core_temperatures() -> Vec<f32> {
    let mut components = COMPONENTS.lock().unwrap();
    components.list_mut().iter_mut().for_each(|c| c.refresh());

    let core_count = get_cpu_core_count();
    let fallback_temp = get_fallback_temperature(&components);

    (0..core_count)
        .map(|i| find_core_temperature(&components, i).unwrap_or(fallback_temp))
        .collect()
}

// get average temperature of cpu
pub fn get_average_temperature() -> f32 {
    let mut components = COMPONENTS.lock().unwrap();

    for component in components.list_mut() {
        component.refresh();
    }

    // Will try to prioritize Tctl if available
    if let Some(temp) = components
        .iter()
        .find(|c| c.label().to_lowercase().contains("tctl"))
        .and_then(|c| c.temperature())
    {
        return temp;
    }

    // If no tctl components are found it does an average of all components related to cpu
    // This may result in some inaccuracy
    let cpu_temps: Vec<f32> = components
        .iter()
        .filter(|component| {
            let label = component.label().to_lowercase();
            label.contains("k10temp")
                || label.contains("coretemp")
                || label.contains("cpu")
                || label.contains("package")
        })
        .filter_map(|component| component.temperature())
        .collect();

    if cpu_temps.is_empty() {
        return 0.0;
    }

    cpu_temps.iter().sum::<f32>() / cpu_temps.len() as f32
}

// get memory usage as percentage
pub fn get_memory_usage_percent() -> f32 {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_memory();

    let total = sys.total_memory();
    if total == 0 {
        return 0.0;
    }

    (sys.used_memory() as f32 / total as f32) * 100.0
}

// get detailed memory information in bytes
pub fn get_memory_info() -> (u64, u64, u64) {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_memory();

    (
        sys.total_memory(),
        sys.used_memory(),
        sys.available_memory(),
    )
}

// get memory temperature if available
pub fn get_memory_temperature() -> Option<f32> {
    let mut components = COMPONENTS.lock().unwrap();
    components.list_mut().iter_mut().for_each(|c| c.refresh());

    components
        .iter()
        .find(|c| {
            let label = c.label().to_lowercase();
            label.contains("ddr") || label.contains("dimm") || label.contains("memory")
        })
        .and_then(|c| c.temperature())
}

// Helper functions

/// Helper: Find temperature sensor for a specific CPU core
fn find_core_temperature(components: &Components, core_index: usize) -> Option<f32> {
    let patterns = [
        format!("tccd{}", core_index + 1), // AMD per-CCD temps
        format!("core {}", core_index),    // Intel with space
        format!("core{}", core_index),     // Intel without space
    ];

    components
        .iter()
        .find(|c| {
            let label = c.label().to_lowercase();
            patterns.iter().any(|p| label.contains(p))
        })
        .and_then(|c| c.temperature())
}

/// Helper: Get fallback temperature (Tctl or average of CPU sensors)
fn get_fallback_temperature(components: &Components) -> f32 {
    // Prefer Tctl sensor
    if let Some(temp) = components
        .iter()
        .find(|c| c.label().to_lowercase().contains("tctl"))
        .and_then(|c| c.temperature())
    {
        return temp;
    }

    // Otherwise average all CPU-related sensors
    let cpu_temps: Vec<f32> = components
        .iter()
        .filter(|c| is_cpu_sensor(c.label()))
        .filter_map(|c| c.temperature())
        .collect();

    if cpu_temps.is_empty() {
        45.0
    } else {
        cpu_temps.iter().sum::<f32>() / cpu_temps.len() as f32
    }
}

/// Helper: Check if sensor label is CPU-related
fn is_cpu_sensor(label: &str) -> bool {
    let label = label.to_lowercase();
    (label.contains("cpu") || label.contains("processor") || label.contains("core"))
        && !label.contains("gpu")
        && !label.contains("nvme")
        && !label.contains("ddr")
        && !label.contains("network")
}

/// Debug helper: Returns a list of all available temperature sensors
#[allow(dead_code)]
pub fn get_all_sensor_names() -> Vec<String> {
    let components = COMPONENTS.lock().unwrap();

    components
        .iter()
        .map(|c| {
            let temp = c.temperature().unwrap_or(0.0);
            format!("{}: {:.1}°C", c.label(), temp)
        })
        .collect()
}
