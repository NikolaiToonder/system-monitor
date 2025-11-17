use qmetaobject::prelude::*;
use rand::Rng;

#[derive(Default, QObject)]
pub struct CpuMonitor {
    base: qt_base_class!(trait QObject),
    cpu_usage: qt_property!(f64; NOTIFY cpu_usage_changed),
    cpu_usage_changed: qt_signal!(),
    
    update_usage: qt_method!(fn(&mut self, new_usage: f64)),
    request_update: qt_method!(fn(&mut self)),
}

impl CpuMonitor {
    fn update_usage(&mut self, new_usage: f64) {
        self.cpu_usage = new_usage;
        self.cpu_usage_changed();
    }

    // Function callable by the qml file!
    fn request_update(&mut self) {
        let mut rng = rand::thread_rng();
        let usage = rng.gen_range(0.0..100.0);
        self.update_usage(usage);
    }
}
