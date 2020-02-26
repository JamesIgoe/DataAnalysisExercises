
import cntk
import numpy as np

x = cntk.input_variable(2)
y = cntk.input_variable(2)
x0 = np.asarray([[2., 1.]], dtype=np.float32)
y0 = np.asarray([[4., 6.]], dtype=np.float32)
cntk.squared_error(x, y).eval({x:x0, y:y0})
array([ 29.], dtype=float32)
















