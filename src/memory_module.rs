use crate::system_instance;
use qmetaobject::*;

#[derive(Default, QObject)]

// Struct directly connected to the memory module of the qml.
pub struct MemoryMonitor {
    //Base fields
    base: qt_base_class!(trait QObject),
    memory_usage_percent: qt_property!(f32; NOTIFY memory_changed),
    memory_total: qt_property!(u64),
    memory_used: qt_property!(u64; NOTIFY memory_changed),
    memory_available: qt_property!(u64; NOTIFY memory_changed),
    memory_temp: qt_property!(f32; NOTIFY memory_changed),

    //Signals
    memory_changed: qt_signal!(),

    //Functions
    request_update: qt_method!(fn(&mut self)),
}

impl MemoryMonitor {
    // Function callable by the qml file!
    fn request_update(&mut self) {
        // Collect memory usage percentage
        let usage_percent = system_instance::get_memory_usage_percent();

        // Collect detailed memory information
        let (total, used, available) = system_instance::get_memory_info();

        // Collect memory temperature if available
        let temp = system_instance::get_memory_temperature().unwrap_or(0.0);

        self.memory_usage_percent = usage_percent;
        self.memory_total = total;
        self.memory_used = used;
        self.memory_available = available;
        self.memory_temp = temp;

        self.memory_changed();
    }
}
