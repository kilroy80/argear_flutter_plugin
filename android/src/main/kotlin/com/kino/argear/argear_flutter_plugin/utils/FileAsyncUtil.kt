package com.kino.argear.argear_flutter_plugin.utils

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL

interface OnAsyncFileDeleteListener {
    fun processFinish(result: Any?)
}

object FileAsyncUtil {

    fun downloadFile(targetPath: String, achieveUrl: String, responseListener: DownloadAsyncResponse?) {
        CoroutineScope(Dispatchers.IO).launch {
            runCatching {
                var success = false
                var fileOutput: FileOutputStream? = null
                var inputStream: InputStream? = null

                try {
                    val url = URL(achieveUrl)
                    val urlConnection = url.openConnection() as HttpURLConnection
                    urlConnection.requestMethod = "GET"
                    urlConnection.doOutput = false
                    urlConnection.connect()

                    val file = File(targetPath)
                    file.createNewFile()

                    fileOutput = FileOutputStream(file)
                    inputStream = urlConnection.inputStream

                    val buffer = ByteArray(1024)
                    var bufferLength: Int
                    var read = 0
                    val total = urlConnection.contentLength
                    while (inputStream.read(buffer).also { bufferLength = it } > 0) {
                        fileOutput.write(buffer, 0, bufferLength)
                        read += bufferLength
                        if (total > 0) {
                            val progress = (100 * (read / total.toFloat())).toInt()
//                          publishProgress(progress)
                        }
                    }
                    success = true

                    responseListener?.processFinish(success)

                } catch (e: IOException) {
                    e.printStackTrace()
                } finally {
                    fileOutput?.let {
                        try {
                            fileOutput.close()
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }
                    inputStream?.let {
                        try {
                            inputStream.close()
                        } catch (e: IOException) {
                            e.printStackTrace()
                        }
                    }
                }
//              return success
            }
        }
    }

    fun deleteFile(directory: File, onAsyncFileDeleteListener: OnAsyncFileDeleteListener?) {
        CoroutineScope(Dispatchers.IO).launch {
            if (directory != null && directory.exists() && directory.listFiles() != null) {
                for (childFile in directory.listFiles()) {
                    if (childFile != null) {
                        if (childFile.isDirectory) {
                            deleteDirectory(childFile)
                        } else {
                            childFile.delete()
                        }
                    }
                }
                directory.delete()
            }
            onAsyncFileDeleteListener?.processFinish(null)
        }
    }

    private fun deleteDirectory(localDirectory: File?) {
        if (localDirectory != null && localDirectory.exists() && localDirectory.listFiles() != null) {
            for (childFile in localDirectory.listFiles()) {
                if (childFile != null) {
                    if (childFile.isDirectory) {
                        deleteDirectory(childFile)
                    } else {
                        childFile.delete()
                    }
                }
            }
        }
    }
}