package com.course.file.controller.admin;

import com.course.server.dto.FileDto;
import com.course.server.dto.ResponseDto;
import com.course.server.enums.FileUseEnum;
import com.course.server.service.FileService;
import com.course.server.util.UuidUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

@RequestMapping("/admin")
@RestController
public class UploadController {
    private static final Logger LOG = LoggerFactory.getLogger(UploadController.class);
    public static final String BUSINESS_NAME= "文件上传";
    //@Value,注入属性值
    @Value("${file.domain}")
    private String FILE_DOMAIN;

    @Value("${file.path}")
    private String FILE_PATH;

    @Resource
    private FileService fileService;

    @RequestMapping("/upload")
    public ResponseDto upload(@RequestParam MultipartFile file,String use) throws IOException {
        LOG.info("上传文件开始");
        LOG.info(file.getOriginalFilename());
        LOG.info(String.valueOf(file.getSize()));

        //保存文件到本地
        FileUseEnum useEnum = FileUseEnum.getByCode(use);
        String key = UuidUtil.getShortUuid();
        String fileName = file.getOriginalFilename();
        String suffix = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

        //如果文件夹不存在则创建
        String dir = useEnum.name().toLowerCase();
        File fullDir = new File(FILE_PATH + dir);
        if(!fullDir.exists()){
            fullDir.mkdirs();
        }
        String path = dir + File.separator + key + "." + suffix;
        String fullPath =FILE_PATH + path;
        File dest = new File(fullPath);
        file.transferTo(dest);
        LOG.info(dest.getAbsolutePath());

        LOG.info("保存文件记录开始");
        FileDto fileDto = new FileDto();
        fileDto.setPath(path);
        fileDto.setName(fileName);
        fileDto.setSize(Math.toIntExact(file.getSize()));
        fileDto.setSuffix(suffix);
        fileDto.setUse(use);
        fileService.save(fileDto);

        ResponseDto responseDto = new ResponseDto();
        fileDto.setPath(FILE_DOMAIN + path);
        responseDto.setContent(fileDto);
        return responseDto;
    }
    @GetMapping("/merge")
    public ResponseDto merge() throws Exception {
        File newFile = new File(FILE_PATH + "/course/fourcat.mp4");
        FileOutputStream outputStream = new FileOutputStream(newFile, true);//文件追加写入
        FileInputStream fileInputStream = null;//分片文件
        byte[] byt = new byte[10 * 1024 * 1024];
        int len;
        try {
            //读取第一个分片
            fileInputStream = new FileInputStream(FILE_PATH + "/course/4aLwGDkg.blob");
            while ((len = fileInputStream.read(byt)) != -1) {
                outputStream.write(byt, 0, len);
            }
            //读取第二个分片
            fileInputStream = new FileInputStream(FILE_PATH + "/course/r6KCYaxa.blob");
            while ((len = fileInputStream.read(byt)) != -1) {
                outputStream.write(byt, 0, len);
            }
        } catch (IOException e) {
            LOG.error("分片合并异常", e);
        }finally {
            try{
                if(fileInputStream != null){
                    fileInputStream.close();
                }
                outputStream.close();
                LOG.info("io流关闭");
            }catch (Exception e){
                LOG.info("io流关闭",e);
            }
        }
        ResponseDto responseDto = new ResponseDto();
        return responseDto;
    }
}
