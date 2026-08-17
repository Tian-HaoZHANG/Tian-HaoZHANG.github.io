#import "../index.typ": template, tufted
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "利用四元数进行卫星坐标系旋转变换"
#let description = "三维转动可以用四元数表示，卫星数据处理中用它来做坐标系旋转变换。"

#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2026, month: 6, day: 10),
  lang: "en",
)

= #title
#description\

== 数学公式

Ref: @book:李文威-代数学讲义.

#image("quaternion_in_space_data_analysis.png")

== Python 代码 - 使用 cdflib

Ref: @website:cdflib-quick-start-guide.

#figure(caption: "导入所需的 Python 库，尤其是阅读 cdf file 的库 cdflib")[
  ```Python
  import glob
  import numpy as np
  import xarray as xr

  import cdflib
  from cdflib import xarray

  print('CDFlib Version\n{}'.format(cdflib.__version__))
  ```
]


#figure(caption: "指定 cdf file 的路径，将其读取为 xarray")[
  ```Python
  # CDF File
  filename = glob.glob(r'D:\下载的文件\PKU\专业课\科研\本科毕业论文\mms_data\mms3\mec\srvy\l2\epht89d\2021\02\mms3_mec_srvy_l2_epht89d_20210205_v2.0.1.cdf')[0]
  print('Filename \n{}'.format(filename))

  # Read CDF [Method #2: Xarray]
  cdf2 = xarray.cdf_to_xarray(filename, to_unixtime=True, fillval_to_nan=True)
  print('\nRead Type: Xarray \n{}'.format(type(cdf2)))
  ```
]





#figure(caption: "将 Epoch 时间转换为 datetime64 格式，一会儿会用到")[
  ```Python
  from typing import Any, Union
  from numpy.typing import NDArray

  def unix2datetime64(time: Union[list[float], NDArray[Any]]) -> NDArray[np.datetime64]:
      r"""Converts unix time to datetime64 in ns units.

      Parameters
      ----------
      time : numpy.ndarray
          Time in unix format.

      Returns
      -------
      time_datetime64 : numpy.ndarray
          Time in datetime64 format.

      Raises
      ------
      TypeError
          If time is not a list or numpy.ndarray.

      See Also
      --------
      pyrfu.pyrf.datetime642unix

      """
      # Check input type
      if isinstance(time, (list, np.ndarray)):
          time_array = np.array(time)
      else:
          raise TypeError("time must be list or numpy.ndarray")

      # Make sure that time is in ns format
      time_unix = (time_array * 1e9).astype(np.int64)

      # Convert to unix
      time_datetime64 = time_unix.astype("datetime64[ns]")

      return time_datetime64

  time_epoch = cdf2['Epoch'].data
  time = unix2datetime64(time_epoch)
  ```
]



#figure(caption: "打印 cdf file 中包含的信息条目，便于寻找所需的 variable")[
  ```Python
  # CDF Summary [Method #2: Xarray]
  print('CDF Summary\n{}'.format(cdf2.info))

  # Individual Global Variables
  print('\n\nIndividual Global Variables')
  for variable in cdf2.attrs:
      print('{}: {}\n'.format(variable, cdf2.attrs[variable]))
  ```
]


#figure(caption: "读取四元数所在的 variable: 从 eci 坐标系转到 gse 坐标系")[
  ```Python
  # Access Variable Data
  variable = 'mms3_mec_quat_eci_to_gse'
  data = cdf2[variable].data
  print('\n{}\n{}\n{}'.format(variable,data,data.shape))

  # Euler parameters
  eci_to_gse_0 = data[:,3]
  eci_to_gse_1 = data[:,0]
  eci_to_gse_2 = data[:,1]
  eci_to_gse_3 = data[:,2]

  # 保存为 dataset 格式
  eci_to_gse = xr.Dataset(
    coords=dict(
        time=time
    ),
    data_vars=dict(
        e0=(["time"], eci_to_gse_0),
        e1=(["time"], eci_to_gse_1),
        e2=(["time"], eci_to_gse_2),
        e3=(["time"], eci_to_gse_3)
    ),
    attrs=dict(
        description="Euler parameters from eci to gse"
    )
  )
  ```
]


#figure(caption: "读取四元数所在的 variable: 从 eci 坐标系转到 bcs")[
  ```Python
  # Access Variable Data
  variable = 'mms3_mec_quat_eci_to_bcs'
  data = cdf2[variable].data
  print('\n{}\n{}\n{}'.format(variable,data,data.shape))

  # Euler parameters：逆变换所用的单位四元数等于正变换所用的单位四元数的共轭
  bcs_to_eci_0 = data[:,3]
  bcs_to_eci_1 = -data[:,0]
  bcs_to_eci_2 = -data[:,1]
  bcs_to_eci_3 = -data[:,2]

  # 保存为 dataset 格式
  bcs_to_eci = xr.Dataset(
      coords=dict(
          time=time
      ),
      data_vars=dict(
          e0=(["time"], bcs_to_eci_0),
          e1=(["time"], bcs_to_eci_1),
          e2=(["time"], bcs_to_eci_2),
          e3=(["time"], bcs_to_eci_3)
      ),
      attrs=dict(
          description="Euler parameters from eci to bcs"
      )
  )
  ```
]

#figure(caption: "四元数相乘：从 bcs 转动到 gse 坐标系；四元数乘法不对易，因此要注意相乘的顺序")[
  ```Python
  # 旋转的合成：四元数乘法 —— 注意相乘的顺序
  # 四元数乘法可以用 Mathematica 计算
  bcs_to_gse_0 = bcs_to_eci_0 * eci_to_gse_0 - bcs_to_eci_1 * eci_to_gse_1 - bcs_to_eci_2 * eci_to_gse_2 - bcs_to_eci_3 * eci_to_gse_3
  bcs_to_gse_1 = eci_to_gse_0 * bcs_to_eci_1 + eci_to_gse_1 * bcs_to_eci_0 + eci_to_gse_2 * bcs_to_eci_3 - eci_to_gse_3 * bcs_to_eci_2
  bcs_to_gse_2 = eci_to_gse_0 * bcs_to_eci_2 - eci_to_gse_1 * bcs_to_eci_3 + eci_to_gse_2 * bcs_to_eci_0 + eci_to_gse_3 * bcs_to_eci_1
  bcs_to_gse_3 = eci_to_gse_0 * bcs_to_eci_3 + eci_to_gse_1 * bcs_to_eci_2 - eci_to_gse_2 * bcs_to_eci_1 + eci_to_gse_3 * bcs_to_eci_0

  # 保存为 dataset 格式
  bcs_to_gse = xr.Dataset(
    coords=dict(
        time=time
    ),
    data_vars=dict(
        e0=(["time"], bcs_to_gse_0),
        e1=(["time"], bcs_to_gse_1),
        e2=(["time"], bcs_to_gse_2),
        e3=(["time"], bcs_to_gse_3)
    ),
    attrs=dict(
        description="Euler parameters from bcs to gse"
    )
  )

  # 保存所得 dataset 至他处，便于下一步使用
  data_to_write = np.column_stack(((time - time[0]).astype('float64') / 1e9, bcs_to_gse_0, bcs_to_gse_1, bcs_to_gse_2, bcs_to_gse_3))
  np.save('quat_bcs_to_gse.npy', data_to_write)
  ```
]


#bibliography("refs.bib")
