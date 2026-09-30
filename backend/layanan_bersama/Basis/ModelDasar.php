<?php

namespace WebeeFlorist\Basis;

use Illuminate\Database\Eloquent\Model as EloquentModel;
use WebeeFlorist\Konfigurasi\BasisData;

abstract class ModelDasar extends EloquentModel
{
    public function __construct(array $attributes = [])
    {
        BasisData::inisialisasi();
        parent::__construct($attributes);
    }

    protected function serializeDate(\DateTimeInterface $date): string
    {
        return $date->format('Y-m-d H:i:s');
    }
}
