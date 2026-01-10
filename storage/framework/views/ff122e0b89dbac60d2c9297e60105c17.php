

<?php $__env->startSection('content'); ?>
<div class="container">
    <h2>Close Shift</h2>

    <p><strong>Pump:</strong> <?php echo e($shift->pump->name); ?></p>
    <p><strong>Opening Meter:</strong> <?php echo e($shift->opening_meter); ?></p>

    <form method="POST" action="<?php echo e(route('shifts.close', $shift)); ?>">
        <?php echo csrf_field(); ?>

        <label>Closing Meter</label>
        <input type="number" step="0.01" name="closing_meter" value="<?php echo e(old('closing_meter')); ?>" required class="border rounded px-2 py-1">

        <?php $__errorArgs = ['closing_meter'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
            <p class="text-red-600"><?php echo e($message); ?></p>
        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>

        <?php if($errors->any()): ?>
            <div class="mb-2 text-red-600">
                <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $e): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <div><?php echo e($e); ?></div>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </div>
        <?php endif; ?>

        <?php if(auth()->user() && auth()->user()->isAdmin()): ?>
            <div class="mt-2">
                <label class="inline-flex items-center">
                    <input type="checkbox" name="force" value="1" class="mr-2"> Force close (admin override)
                </label>
            </div>
        <?php endif; ?>

        <button type="submit" class="btn btn-danger mt-3">
            Close Shift
        </button>
    </form>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\SHAYO\Desktop\laravel\tracking\resources\views/shifts/close.blade.php ENDPATH**/ ?>