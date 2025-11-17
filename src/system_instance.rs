use sysinfo::System;
use std::sync::Mutex;
use once_cell::sync::Lazy;

// Singleton for fetching system info, this class is responsible for fetching specific information from sysinfo
pub static SYSTEM: Lazy<Mutex<System>> = Lazy::new(|| {
    Mutex::new(System::new_all())
});

pub fn get_global_cpu_usage() -> f32 {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_all();
    
    if sys.cpus().is_empty() {
        return 0.0;
    }
    
    // Get average CPU usage across all cores
    let total: f32 = sys.cpus().iter().map(|cpu| cpu.cpu_usage()).sum();
    return total / sys.cpus().len() as f32
}

// Helper to get individual CPU core usage
pub fn get_cpu_core_usage(core_index: usize) -> Option<f32> {
    let mut sys = SYSTEM.lock().unwrap();
    sys.refresh_all();
    
    sys.cpus().get(core_index).map(|cpu| cpu.cpu_usage() as f32)
}

pub fn get_cpu_core_count() -> usize {
    let sys = SYSTEM.lock().unwrap();
    return sys.cpus().len()
}

