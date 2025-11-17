use qmetaobject::prelude::*;
use crate::system_instance;

#[derive(Default, QObject)]

// Struct directly connected to the cpu module of the qml. 
pub struct CpuMonitor {
    base: qt_base_class!(trait QObject),
    cpu_usage: qt_property!(f32; NOTIFY cpu_usage_changed),
    cpu_usage_changed: qt_signal!(),
    
    update_usage: qt_method!(fn(&mut self, new_usage: f32)),
    request_update: qt_method!(fn(&mut self)),
}

impl CpuMonitor {
    fn update_usage(&mut self, new_usage: f32) {
        self.cpu_usage = new_usage;
        self.cpu_usage_changed();
    }

    // Function callable by the qml file!
    fn request_update(&mut self) {
        let usage = system_instance::get_global_cpu_usage();
        self.update_usage(usage);
    }
}
